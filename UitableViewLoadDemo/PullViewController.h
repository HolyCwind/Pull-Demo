//
//  PullViewController.h
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullViewController : UITableViewController
@property (nonatomic, weak) UIView *footView;
@property (nonatomic, weak) UILabel *footLable;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)addFootView;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;            //Overide to reload data
@end
