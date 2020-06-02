//
//  SwitchTableViewCell.h
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell
@property (nonatomic, strong) UISwitch *cellSwitch;
@property (nonatomic, strong) UILabel *switchLabel;
- (void) setSwitchListener:(UIViewController *)viewController;

@end
