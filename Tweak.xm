#import "NBNotificationFilter.h"
#import <Cephei/HBPreferences.h>


@interface BBBulletinRequest
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSString * subtitle; 
@property (nonatomic,copy) NSString * message;
@end

@interface BBServer
-(void)_publishBulletinRequest:(id)arg1 forSectionID:(id)arg2 forDestinations:(unsigned long long)arg3 alwaysToLockScreen:(BOOL)arg4 ;
@end

NSMutableDictionary *filters;


%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig;

	//do in background thread
	HBPreferences *defaults = [[HBPreferences  alloc] initWithIdentifier:@"com.shemeshapps.notiblock"];
	NSData *data  = [defaults objectForKey:@"filter_array"];
	if (data != nil) {
		filters = [[NSMutableDictionary alloc] init];
		NSArray *dictFilterarray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
		for (NSDictionary * dict in dictFilterarray) {

			NotificationFilter *filter = [[NotificationFilter alloc] initWithDictionary:dict];
			NSString *dictKey = @"";
			if (filter.appToBlock != nil) {
				dictKey = filter.appToBlock.appIdentifier;
			}
			
			if (![filters objectForKey:dictKey]) {
				[filters setObject:[[NSMutableArray alloc] init] forKey:dictKey];
			} 

			NSMutableArray *appIdfilters = [filters objectForKey:dictKey];
			[appIdfilters addObject:filter];
		}
	}
}

%end



%hook BBServer

-(void)_publishBulletinRequest:(id)arg1 forSectionID:(id)arg2 forDestinations:(unsigned long long)arg3 alwaysToLockScreen:(BOOL)arg4 {
	HBLogDebug(@"Entered publish bulletin");
	HBLogDebug(@"HODOR Title: %@      Subtitle: %@         Message: %@",((BBBulletinRequest *)arg1).title, ((BBBulletinRequest *)arg1).subtitle, ((BBBulletinRequest *)arg1).message );

	BOOL filtered = NO;
	 
	if (filters == nil) {
		HBLogDebug(@"No filters. returning");
		%orig;
		return;
	}
	
	
	NSMutableArray *allFilters = [filters objectForKey:@""];

	NSMutableArray *appFilters  = [filters objectForKey:(NSString *)arg2];
	if (appFilters != nil) {
		allFilters = [[allFilters arrayByAddingObjectsFromArray:appFilters] mutableCopy];
	}

    HBLogDebug(@"loading relevant filters: %lu", (unsigned long)[allFilters count]);


	BBBulletinRequest *request = ((BBBulletinRequest *)arg1);
	NSString *title = [request.title lowercaseString];
	NSString *subtitle = [request.subtitle lowercaseString];
	NSString *message = [request.message lowercaseString];

	if (title == nil) {
		title = @"";
	}
	
	if (subtitle == nil) {
		subtitle = @"";
	}	
	
	if (message == nil) {
		message = @"";
	}
	
	for (NotificationFilter *filter in allFilters) {

		NSString *filterText = [filter.filterText lowercaseString];
		//do filtering
		if (filter.blockType == 0) { //starts with
			if ([title hasPrefix:filterText] || [subtitle hasPrefix:filterText] || [message hasPrefix:filterText] ) {
				filtered = YES;	
			}
		} else if (filter.blockType == 1) { //ends with
			if ([title hasSuffix:filterText] || [subtitle hasSuffix:filterText] || [message hasSuffix:filterText] ) {
				filtered = YES;	
			}
		} else if (filter.blockType == 2) { //contains
			HBLogDebug(@"checking if string contains text");

			if ([title rangeOfString:filterText].location != NSNotFound || [subtitle rangeOfString:filterText].location != NSNotFound || [message rangeOfString:filterText].location != NSNotFound) {
				HBLogDebug(@"string contains match. filtering turned on");
				filtered = YES;	
			} 
		} else if (filter.blockType == 3) { //exact text
			if ([title isEqualToString:filterText] || [subtitle isEqualToString:filterText] || [message isEqualToString:filterText]) {
				filtered = YES;	
			} 
		} else if (filter.blockType == 4) { //regex
			NSPredicate *notifTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterText]; 
			if ([notifTest evaluateWithObject: [NSString stringWithFormat:@"%@ %@ %@",title,subtitle,message]]) {
				filtered = YES;
			}
		} else if (filter.blockType == 5) { //always
			filtered = YES;
		} 
		//check for schedule
		if (filtered && filter.onSchedule) {

		}
	}

	

	//HBLogDebug(@"HODOR Title: %@      Subtitle: %@         Message: %@",((BBBulletinRequest *)arg1).title, ((BBBulletinRequest *)arg1).subtitle, ((BBBulletinRequest *)arg1).message );
	 // HBLogDebug(@"HODOR 2 %@",(NSString *)arg2);
	 // HBLogDebug(@"HODOR 3 %llu",arg3);

	if(!filtered) {
	 	%orig;  //(arg1,@"com.outdoorfoundation.oncampuschallenge",arg3, arg4);
	}

}

%end


// HODOR Title: Stephen Hayes      Subtitle: To you‎ & Jonathen         Message: Oooh that's actually a really good one
// HODOR Title: Noah and Waseh      Subtitle: (null)         Message: Noah Abbott: Parameters. I'll explain em tomorrow
// HODOR Title: (null)      Subtitle: (null)         Message: Huh
// HODOR Title: Hangouts      Subtitle: (null)         Message: sdf
// HODOR Title: (null)      Subtitle: (null)         Message: ‎etanshemesh99 is typing...
