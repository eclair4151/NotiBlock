#import "NBPRootListController.h"
#import "NBPRootTableViewController.h"

//its the whole root prefecen controller. need to rename
@implementation NBPRootListController 

- (void)loadView {
	[super loadView];
    //self.title = @"New Notification Filter";


	//UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
	//self.navigationController.navigationBar.topItem.rightBarButtonItem = doneBtn;


    //CGRect(x,y,width,height)
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)onTapDone:(UIBarButtonItem*)item{

}

-(void)viewFilters {
	

     NBPRootTableViewController *vc = [[NBPRootTableViewController alloc] init];
	 [self.navigationController pushViewController:vc animated:YES];
 }
@end


