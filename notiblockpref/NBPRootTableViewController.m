int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }


#import "NBPRootTableViewController.h"
#import <Cephei/HBPreferences.h>


@interface NBPRootTableViewController ()
@property NSMutableArray *filterList;
@end

@implementation NBPRootTableViewController 


- (void)loadView {
	[super loadView];
	[self load];

	HBPreferences *defaults = [[HBPreferences  alloc] initWithIdentifier:@"com.shemeshapps.notiblock"];
    [defaults setInteger:5 forKey:@"filters"];

	if (self.filterList == nil) {
		self.filterList = [[NSMutableArray alloc] init];
	}
	self.title = @"Notification Filters";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)] autorelease];
}

- (void)addButtonTapped:(id)sender {	
    NBPAddViewController *one = [[[NBPAddViewController alloc]init] autorelease];
	one.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:one];
	if (@available(iOS 13, *)) {
        navController.modalInPresentation = YES;
	}
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.filterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

    cell.textLabel.text = ((NotificationFilter *)self.filterList[indexPath.row]).filterName;
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.filterList removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
	[self save];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 NBPAddViewController *one = [[[NBPAddViewController alloc]init] autorelease];
	one.delegate = self;
	one.currentFilter = [self.filterList objectAtIndex:indexPath.row];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:one];
    if (@available(iOS 13, *)) {
        navController.modalInPresentation = YES;
	}
	[self presentViewController:navController animated:YES completion:nil];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//just save everything check if in array and if so replace otherwise add at end
-(void)newFilter:(NotificationFilter *)filter {
	if (![self.filterList containsObject:filter]) {
		[self.filterList addObject:filter];
		[self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:self.filterList.count-1 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		[self.tableView reloadData];
	}
	[self save];
}
	
-(void)save {
	NSMutableArray *dictFilterarray = [[NSMutableArray alloc] init];
	for (NotificationFilter *filter in self.filterList) {
		[dictFilterarray addObject:[filter encodeToDictionary]];
	}
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictFilterarray];
	HBPreferences *defaults = [[HBPreferences  alloc] initWithIdentifier:@"com.shemeshapps.notiblock"];
    [defaults setObject:data forKey:@"filter_array"];
}
 
-(void)load {
	HBPreferences *defaults = [[HBPreferences  alloc] initWithIdentifier:@"com.shemeshapps.notiblock"];
	NSData *data  = [defaults objectForKey:@"filter_array"];
    NSArray *dictFilterarray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];

	self.filterList = [[NSMutableArray alloc] init];
	for (NSDictionary * dict in dictFilterarray) {
		[self.filterList addObject:[[NotificationFilter alloc] initWithDictionary:dict]];
	}
 }

@end
