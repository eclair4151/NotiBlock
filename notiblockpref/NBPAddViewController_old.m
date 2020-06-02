#import "NBPAddViewController.h"
#import "NBPDatePickerTableViewCell.h"

@implementation NBPAddViewController {
	//NSMutableArray *_objects;
}

- (void)loadView {
	[super loadView];
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //84 is stuff below baner and status bar
    int vertHeight = 70;
    int viewWidth = self.view.frame.size.width;
    self.title = @"New Notification Filter";

	UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
	self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelBtn;
	UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
	self.navigationController.navigationBar.topItem.rightBarButtonItem = doneBtn;


    UILabel *blockIf = [[UILabel alloc] initWithFrame:CGRectMake(16, vertHeight, viewWidth - 32, 22)];
    blockIf.text = @"Block the Notification if it:";
    UIFont* boldFont = [UIFont boldSystemFontOfSize:17];
    [blockIf setFont:boldFont];
    [self.view addSubview:blockIf];
    vertHeight += 22;
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, vertHeight, viewWidth, 85)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView];
    vertHeight += 85;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UITextField *stringToBlock = [[UITextField alloc] initWithFrame:CGRectMake(0, vertHeight, viewWidth, 30)];
    stringToBlock.placeholder = @"Enter text here";
    stringToBlock.leftView = paddingView;
    stringToBlock.leftViewMode = UITextFieldViewModeAlways;
    stringToBlock.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stringToBlock];
    vertHeight += 45;


    UIButton *selectAppButton = [[UIButton alloc] initWithFrame:CGRectMake(8, vertHeight, 200, 30)];
    [selectAppButton addTarget:self action:@selector(selectAppPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectAppButton setTitle:@"Select App To Block..." forState:UIControlStateNormal];
    [selectAppButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:selectAppButton];
    vertHeight += 45;

    UISwitch *onSchedule = [[UISwitch alloc] initWithFrame:CGRectMake(8, vertHeight, 49, 31)];
    [onSchedule setOn:NO animated:NO];
    [self.view addSubview:onSchedule];
    vertHeight += 5;

    UILabel *onScheduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, vertHeight, 200, 22)];
    onScheduleLabel.text = @"Block on schedule";
    boldFont = [UIFont boldSystemFontOfSize:16];
    [onScheduleLabel setFont:boldFont];
    [self.view addSubview:onScheduleLabel];
    vertHeight += 30;

    UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(16, vertHeight, 150, 22)];
    startTime.text = @"Start Time:";
    boldFont = [UIFont boldSystemFontOfSize:17];
    [startTime setFont:boldFont];
    [self.view addSubview:startTime];
    vertHeight += 22;

    UIDatePicker *startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, vertHeight, viewWidth, 85)];
    startTimePicker.datePickerMode = UIDatePickerModeTime;
    startTimePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:startTimePicker];
    vertHeight += 90;

    UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(16, vertHeight, 150, 22)];
    endTime.text = @"End Time:";
    boldFont = [UIFont boldSystemFontOfSize:17];
    [endTime setFont:boldFont];
    [self.view addSubview:endTime];
    vertHeight += 22;

    UIDatePicker *endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, vertHeight, viewWidth, 85)];
    endTimePicker.datePickerMode = UIDatePickerModeTime;
    endTimePicker.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:endTimePicker];
    vertHeight += 85;

    NSArray *weekdays = [NSArray arrayWithObjects: @"Sun", @"Mon", @"Tue", @"Wed", @"Thu",@"Fri", @"Sat", nil];
    for (int i = 0; i < 7; i++) {
        UIButton *weekdayButton = [[UIButton alloc] initWithFrame:CGRectMake(i*viewWidth/7, vertHeight, viewWidth/7, 40)];
        weekdayButton.tag = i;

        weekdayButton.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:236.0/255.0 blue:122.0/255.0 alpha:.54];

        [weekdayButton setTitle:weekdays[i] forState:UIControlStateNormal];
        [weekdayButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [weekdayButton addTarget:self action:@selector(weekdayPressed:) forControlEvents:UIControlEventTouchUpInside];
        [weekdayButton.layer setBorderWidth:0.5];
        [weekdayButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [self.view addSubview:weekdayButton];
    
    }
    vertHeight += 40;

    //CGRect(x,y,width,height)
}

- (IBAction)weekdayPressed:(id)sender {

} 

- (IBAction)selectAppPressed:(id)sender {

}   //Write a code you want to execute on buttons click event


-(void)onTapDone:(UIBarButtonItem*)item{

}

-(void)onTapCancel:(UIBarButtonItem*)item{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row)
    {
      case 0:
        return @"Starts with:";
      case 1:
        return @"Ends with:";
      case 2:
        return @"Contains the text:";
      case 3:
        return @"Is the exact text:";
      case 4:        
        return @"Matches regex:";
      case 5:
        return @"Always"; //on select always grey out text bar
      default:
        return @"";
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;  // Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;//Or, return as suitable for you...normally we use array for dynamic
}

@end
