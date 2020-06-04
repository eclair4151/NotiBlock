#import "notiblockpref/NBPNotificationFilter.h"
#import <Cephei/HBPreferences.h>

@interface BBSound
@end

@interface BBBulletinRequest
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSString * subtitle; 
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * bulletinID; 
@property (nonatomic,copy) NSString * sectionID; 
@property (nonatomic,retain) BBSound * sound; 
@property (assign,nonatomic) BOOL turnsOnDisplay; 
@end

@interface BBBulletin : BBBulletinRequest
@end

@interface BBServer
-(void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
-(void)_clearBulletinIDs:(id)arg1 forSectionID:(id)arg2 shouldSync:(BOOL)arg3;
@end

@interface NCNotificationViewController: UIViewController
@end

@interface NCNotificationShortLookViewController: NCNotificationViewController
-(id)_initWithNotificationRequest:(id)arg1 revealingAdditionalContentOnPresentation:(BOOL)arg2 ;
-(id)_scrollView;
@end

@interface NCNotificationRequest
@property (nonatomic,readonly) BBBulletin * bulletin; 
@end

@interface NotiBlockChecker : NSObject
+ (int)blockTypeForBulletin:(BBBulletin *)bulletin;
+ (BOOL)areWeCurrentlyInSchedule:(NSDate *)startTime arg2:(NSDate *)endTime arg3:(NSArray *)weekdays;
+ (BOOL)doesMessageMatchFilterType:(BOOL)titleMatches arg2:(BOOL)subtitleMatches arg3:(BOOL)messageMatches  arg4:(int)filterType;
@end

NSMutableDictionary *filters;



@implementation NotiBlockChecker

/**
returns whether a message should be filtered based on some boolean logic of filters
**/
+ (BOOL)doesMessageMatchFilterType:(BOOL)titleMatches arg2:(BOOL)subtitleMatches arg3:(BOOL)messageMatches  arg4:(int)filterType {
	HBLogDebug(@"NOTIBLOCK - checking matched: title: %@, subtitle: %@, message: %@, filterType: %d",(titleMatches ? @"true" : @"false"), (subtitleMatches ? @"true" : @"false"), (messageMatches ? @"true" : @"false"), filterType);
	if (filterType == 0) {
		return titleMatches || titleMatches || messageMatches;
	} else if (filterType == 1) {
		return titleMatches;
	} else if (filterType == 2) {
		return subtitleMatches;
	} else if (filterType == 3) {
		return messageMatches;
	}
	return NO;
}

/**
returns whether we are currently inbetween the start time and and time and on a weekday set to true in an array of bools
**/
+(BOOL)areWeCurrentlyInSchedule:(NSDate *)startTime arg2:(NSDate *)endTime arg3:(NSArray *)weekdays {
	HBLogDebug(@"NOTIBLOCK - checking schedule");

	NSDate *curTime = [NSDate date];


	NSCalendar *calendar = [NSCalendar currentCalendar];

	NSDateComponents *startComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startTime];
	NSCalendar *newStartCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *newStartTime = [newStartCalendar dateBySettingHour:[startComponents hour] minute:[startComponents minute] second:0 ofDate:curTime options:0];
	
	NSDateComponents *endComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endTime];
	NSCalendar *newEndCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *newEndTime = [newEndCalendar dateBySettingHour:[endComponents hour] minute:[endComponents minute] second:0 ofDate:curTime options:0];
	

	NSInteger curWeekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday 
                                                   fromDate:curTime] - 1;
	//day of week is not selected
	if (![((NSNumber *)weekdays[curWeekday]) boolValue]) {
		HBLogDebug(@"NOTIBLOCK - day is not active. skipping filter");
		return false;
	} 

	if ([[newStartTime earlierDate:newEndTime] isEqualToDate:newEndTime]) { //backwards (start time before end time)
		HBLogDebug(@"NOTIBLOCK - backwards schedule mode");
		return [[newEndTime earlierDate:curTime] isEqualToDate:newEndTime] || [[newStartTime earlierDate:curTime] isEqualToDate:curTime];
	} else { //regular, check for in between

		HBLogDebug(@"NOTIBLOCK - regular schedule mode");
		HBLogDebug(@"NOTIBLOCK - is after start - curTime: %f", [curTime timeIntervalSince1970]);	
		HBLogDebug(@"NOTIBLOCK - is after start - newStartTime: %f", [newStartTime timeIntervalSince1970]);	
		HBLogDebug(@"NOTIBLOCK - is after start - newEndTime: %f", [newEndTime timeIntervalSince1970]);	

		HBLogDebug(@"NOTIBLOCK - is after start - %@",([[newStartTime earlierDate:curTime] isEqualToDate:newStartTime] ? @"true" : @"false"));
		HBLogDebug(@"NOTIBLOCK - is before end - %@",([[newEndTime earlierDate:curTime] isEqualToDate:curTime] ? @"true" : @"false"));
		return [[newEndTime earlierDate:curTime] isEqualToDate:curTime] && [[newStartTime earlierDate:curTime] isEqualToDate:newStartTime];
	}
}

/**
0 - do not block
1 - soft block, show in lock screen
2 - hard block, clear from notifications
**/
+ (int)blockTypeForBulletin:(BBBulletin *)bulletin {
	NSString *title = [bulletin.title lowercaseString];
	NSString *subtitle = [bulletin.subtitle lowercaseString];
	NSString *message = [bulletin.message lowercaseString];
	NSString *bulletinID = bulletin.bulletinID;
	NSString *sectionId =  bulletin.sectionID;

    HBLogDebug(@"NOTIBLOCK - Entered publish bulletin for %@ with ID: %@ ", sectionId, bulletinID);

	HBLogDebug(@"NOTIBLOCK - BulletinID:%@         Title: %@      Subtitle: %@         Message: %@", bulletinID, title, subtitle, message );

	BOOL filtered = NO;
	 
	if (filters == nil) {
		HBLogDebug(@"NOTIBLOCK - No filters. returning");
		return 0;
	}
	
	HBLogDebug(@"NOTIBLOCK - loading all filters: %lu", (unsigned long)[filters count]);
		
	NSMutableArray *allFilters = [filters objectForKey:@""];
	NSMutableArray *appFilters  = [filters objectForKey:sectionId];

    if (allFilters == nil) {
		allFilters = [[NSMutableArray alloc] init];
	}

	if (appFilters != nil) {
		allFilters = [[allFilters arrayByAddingObjectsFromArray:appFilters] mutableCopy];
	}

    HBLogDebug(@"NOTIBLOCK - loading relevant filters for --%@--: %lu",sectionId, (unsigned long)[allFilters count]);
	
	if (title == nil) {
		title = @"";
	}
	
	if (subtitle == nil) {
		subtitle = @"";
	}	
	
	if (message == nil) {
		message = @"";
	}
	
	BOOL showInNotificationCenter = false;
	for (NotificationFilter *filter in allFilters) {

		//check for schedule and skip if not inside
		if (filter.onSchedule && ![self areWeCurrentlyInSchedule:filter.startTime arg2:filter.endTime arg3:filter.weekDays]) {
			//not inside schedule, skip
			HBLogDebug(@"NOTIBLOCK - schedule was on, but we determined it is not currently active. skipping filter");
			continue;
		}

		NSString *filterText = [filter.filterText lowercaseString];
		BOOL titleMatches = false;
		BOOL subtitleMatches = false;
		BOOL messageMatches = false;

		//do filtering
		if (filter.blockType == 0) { //starts with
			HBLogDebug(@"NOTIBLOCK - checking if string starts with text");
			titleMatches = [title hasPrefix:filterText];
			subtitleMatches = [subtitle hasPrefix:filterText];
			messageMatches = [message hasPrefix:filterText];
		} else if (filter.blockType == 1) { //ends with
			HBLogDebug(@"NOTIBLOCK - checking if string end with text");
			titleMatches = [title hasSuffix:filterText];
			subtitleMatches = [subtitle hasSuffix:filterText];
			messageMatches = [message hasSuffix:filterText];
		} else if (filter.blockType == 2) { //contains
			HBLogDebug(@"NOTIBLOCK - checking if string contains text");
			titleMatches = [title rangeOfString:filterText].location != NSNotFound;
			subtitleMatches = [subtitle rangeOfString:filterText].location != NSNotFound;
			messageMatches = [message rangeOfString:filterText].location != NSNotFound;
		} else if (filter.blockType == 3) { //exact text
			HBLogDebug(@"NOTIBLOCK - checking if string matches text");
			titleMatches = [title isEqualToString:filterText];
			subtitleMatches = [subtitle isEqualToString:filterText];
			messageMatches = [message isEqualToString:filterText];
		} else if (filter.blockType == 4) { //regex
			HBLogDebug(@"NOTIBLOCK - checking if string matches regex");
			NSPredicate *notifTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterText]; 
			titleMatches = ![title isEqualToString:@""] && [notifTest evaluateWithObject: title];
			subtitleMatches = ![subtitle isEqualToString:@""] && [notifTest evaluateWithObject: subtitle];
			messageMatches = ![message isEqualToString:@""] && [notifTest evaluateWithObject: message];
		} else if (filter.blockType == 5) { //always
			HBLogDebug(@"NOTIBLOCK - app should always be filtered. filtering turned on");
			filtered = YES;
		} 

		if ([self doesMessageMatchFilterType:titleMatches arg2:subtitleMatches arg3:messageMatches  arg4:filter.filterType]) {
			HBLogDebug(@"NOTIBLOCK - filtering was matched");
			filtered = YES;	
		}

		if (filter.whitelistMode) {
			HBLogDebug(@"NOTIBLOCK - whitelist Mode on");
			filtered = !filtered;
		}

		if (filter.showInNotificationCenter) {
			showInNotificationCenter = YES;
		}
		
	}

	if (filtered) {
		if (showInNotificationCenter) {
			return 1;
		} else {
			return 2;
		}
	} else {
		return 0;
	}
}

@end




%hook SpringBoard

/**
Loads filters into memory from disk when springboard is loaded
**/
-(void)applicationDidFinishLaunching:(id)application {
    %orig;

	HBLogDebug(@"NOTIBLOCK - springboard launch");

	//do in background thread?
	HBPreferences *defaults = [[HBPreferences  alloc] initWithIdentifier:@"com.shemeshapps.notiblock"];
	NSData *data  = [defaults objectForKey:@"filter_array"];

	HBPreferences *prefDefaults = [[HBPreferences  alloc] initWithIdentifier:@"com.shemeshapps.notiblockpref"];
	BOOL enabled  = [prefDefaults boolForKey:@"enabled"];

	for (NSString *key in [[prefDefaults dictionaryRepresentation] allKeys]) {
		HBLogDebug(@"NOTIBLOCK - pref keys: %@", key);
	}

	if(!enabled) {
		HBLogDebug(@"NOTIBLOCK - tweak disabled. not loading filters");
		return;
	} 

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

			HBLogDebug(@"NOTIBLOCK - adding filter to dict for appkey: --%@--", dictKey);

		}
	} else {
		HBLogDebug(@"NOTIBLOCK - springboard data load was nil");
	}
}

%end



/**
Code to hide the banner dropdown view
**/
%hook NCNotificationShortLookViewController

-(id)_initWithNotificationRequest:(id)arg1 revealingAdditionalContentOnPresentation:(BOOL)arg2 {
	BBBulletin *bulletin = ((NCNotificationRequest *)arg1).bulletin;
	NCNotificationShortLookViewController *temp = %orig;
	
	if ([NotiBlockChecker blockTypeForBulletin: bulletin] != 0) {
		self.view.hidden = YES;
		[self.view setUserInteractionEnabled:NO];
	}
	return temp;
}
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	if(self.view.hidden) {
		HBLogDebug(@"NOTIBLOCK - NCNotificationShortLookViewController will appear - dismissing banner");
		[self dismissViewControllerAnimated:NO completion:nil];
	}
}

%end




%hook BBServer

/**
Check for filters and block notifications if needed
**/
-(void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2 {
	BBBulletin *bulletin = ((BBBulletin *)arg1);

	int blockType = [NotiBlockChecker blockTypeForBulletin: bulletin];
	if (blockType == 0) {
		%orig;
		return;
	}

	bulletin.sound = nil;
	bulletin.turnsOnDisplay = NO;
    %orig(bulletin, arg2);

	if (blockType == 2) {
		[self _clearBulletinIDs:@[bulletin.bulletinID] forSectionID:bulletin.sectionID shouldSync:YES];
	}
}

%end