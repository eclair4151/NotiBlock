#import "NBPAppChooserViewController.h"
#import "NBPNotificationFilter.h"

@protocol AppFilterDelegate <NSObject>
-(void)newFilter:(NotificationFilter *)filter;
@end

@interface NBPAddViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, AppChoserDelegate, UITextFieldDelegate>
@property (nonatomic, retain) id <AppFilterDelegate> delegate;
@property (nonatomic, retain) NotificationFilter *currentFilter;

@end