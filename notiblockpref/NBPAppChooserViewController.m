//
//  NBPAppChooserViewController.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPAppChooserViewController.h"
#import "NBPAppListTableViewCell.h"
#import "NBPAppInfo.h"
#import <AppList/AppList.h>


@interface AppChooserViewController ()
@property UITableView *tableView;
@property NSMutableArray *systemApplications;
@property NSMutableArray *userApplications;
@end

@implementation AppChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.systemApplications = [[NSMutableArray alloc] init];
    self.userApplications = [[NSMutableArray alloc] init];

    NSArray *tmpSortedDisplayIdentifiers;
    NSDictionary *systemApps = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:[NSPredicate predicateWithFormat:@"isSystemApplication = TRUE"]
    onlyVisible:YES titleSortedIdentifiers:&tmpSortedDisplayIdentifiers];

    NSDictionary *userApps = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:[NSPredicate predicateWithFormat:@"isSystemApplication = FALSE"]
    onlyVisible:YES titleSortedIdentifiers:&tmpSortedDisplayIdentifiers];


    for (NSString* identifier in systemApps) {
        NSString *appName = systemApps[identifier];
        AppInfo *info = [[AppInfo alloc] init];
        info.appName = appName;
        info.appIdentifier = identifier;
        [self.systemApplications addObject:info];
    }

    for (NSString* identifier in userApps) {
        NSString *appName = userApps[identifier];
        AppInfo *info = [[AppInfo alloc] init];
        info.appName = appName;
        info.appIdentifier = identifier;
        [self.userApplications addObject:info];
    }

    [self.systemApplications sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = ((AppInfo*)a).appName;
        NSString *second = ((AppInfo*)b).appName;
        return [first compare:second];
    }];

    [self.userApplications sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = ((AppInfo*)a).appName;
        NSString *second = ((AppInfo*)b).appName;
        return [first compare:second];
    }];


    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell"];
    ALApplicationList *appList = [ALApplicationList sharedApplicationList];

    if (cell == nil) {
        cell = [[AppListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppCell"];
    }
    if (indexPath.section == 0) {
        cell.appName.text = @"Filter From All Apps";
        cell.appIcon.image = nil;
    } else if (indexPath.section == 1) {    
        cell.appName.text = ((AppInfo *)self.systemApplications[indexPath.row]).appName;
        UIImage *icon = [appList iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:((AppInfo *)self.systemApplications[indexPath.row]).appIdentifier];
        cell.appIcon.image = icon;
    } else if (indexPath.section == 2) {
        cell.appName.text = ((AppInfo *)self.userApplications[indexPath.row]).appName;
        UIImage *icon = [appList iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:((AppInfo *)self.userApplications[indexPath.row]).appIdentifier];
        cell.appIcon.image = icon;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.systemApplications.count;
    } else if (section == 2) {
        return self.userApplications.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.delegate appChosen:nil];
    } else if (indexPath.section == 1) {
        [self.delegate appChosen:((AppInfo *)self.systemApplications[indexPath.row])];
    } else if (indexPath.section == 2){
        [self.delegate appChosen:((AppInfo *)self.userApplications[indexPath.row])];
    }
  [[self navigationController] popViewControllerAnimated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section){
        case 0:
            return @"All Apps";
        case 1:
            return @"System Apps";
        case 2:
            return @"User Apps";
    
    } 
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end

