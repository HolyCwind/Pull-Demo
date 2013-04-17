//
//  DemoViewController.h
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"
#import "RefreshTableFooterView.h"

typedef enum{
  REFRESHHead = 0,
  REFRESHFoot,
} RefreshType;

@interface DemoViewController : UITableViewController <RefreshTableHeaderDelegate,RefreshTableFooterDelegate>
@property (nonatomic, weak) RefreshTableHeaderView *headerView;
@property (nonatomic, weak) RefreshTableFooterView *footerView;
@property (nonatomic) RefreshType refreshType;
@property (nonatomic) BOOL isLoading;

- (void)reloadTableViewDataSource;
- (void)doneLoadTableViewData;
@end
