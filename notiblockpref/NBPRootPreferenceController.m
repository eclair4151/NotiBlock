#import "NBPRootPreferenceController.h"
#import "NBPRootTableViewController.h"
#import <Cephei/HBRespringController.h>

//its the whole root preference controller. need to rename
@implementation NBPRootPreferenceController 

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)onTapDone:(UIBarButtonItem*)item{

}

-(void)viewFilters {
     NBPRootTableViewController *vc = [[NBPRootTableViewController alloc] init];
	 [self.navigationController pushViewController:vc animated:YES];
 }

-(void)respringPhone {
	NSLog(@"NOTIBLOCK - respring phone");
	[HBRespringController respring];
}
 
@end


