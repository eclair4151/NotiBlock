//
//  NBPAppChooserViewController.h
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//
#import "NBPAppInfo.h"

@protocol AppChoserDelegate <NSObject>
-(void)appChosen:(AppInfo *)app;
@end

#import <UIKit/UIKit.h>

@interface AppChooserViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) id <AppChoserDelegate> delegate;
@end

