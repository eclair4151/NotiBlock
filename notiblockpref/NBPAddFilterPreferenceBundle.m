// #import "NBPAddFilterPreferenceBundle.h"
// #import <Preferences/PSSpecifier.h> 

// @implementation NBPAddFilterPreferenceBundle 


// - (id)readPreferenceValue:(PSSpecifier*)specifier {
// 	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
// 	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
// 	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
// 	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
// }

// - (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
// 	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
// 	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
// 	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
// 	[settings setObject:value forKey:specifier.properties[@"key"]];
// 	[settings writeToFile:path atomically:YES];
// 	CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
// 	if (notificationName) {
// 		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
// 	}
// }

// // - (void)loadView {
// // 	[super loadView];
// //     self.title = @"New Notification Filter";


// // 	UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
// // 	self.navigationController.navigationBar.topItem.rightBarButtonItem = doneBtn;


// //     //CGRect(x,y,width,height)
// // }

// - (NSArray *)specifiers {
// 	if (!_specifiers) {
// 		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
// 	}

// 	return _specifiers;
// }

// -(void)onTapDone:(UIBarButtonItem*)item{

// }

// -(void)viewFilters {
	

//      NBPRootTableViewController *vc = [[NBPRootTableViewController alloc] init];
// 	 [self.navigationController pushViewController:vc animated:YES];
//  }
// @end
