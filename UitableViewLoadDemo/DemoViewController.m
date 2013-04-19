//
//  DemoViewController.m
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import "DemoViewController.h"


@interface DemoViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DemoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Pull Demon";
  NSMutableArray *array = [NSMutableArray array];
  for (int i= 0; i < 10; i++) {
    [array addObject:[NSString stringWithFormat:@"%d",i]];
  }
  self.dataArray = array;
  self.isLoading = NO;
  
  if (self.headerView == nil) {
    RefreshTableHeaderView *headerView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.bounds.size.height, 320, self.tableView.bounds.size.height)];
    headerView.delegate = self;
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
  }
  
  if (self.footerView == nil) {
    RefreshTableFooterView *footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0, MAX(self.dataArray.count * 44,self.tableView.bounds.size.height - 44), 320, self.tableView.bounds.size.height)];
    NSLog(@"%f",footerView.frame.origin.y);
    footerView .delegate = self;
    [self.tableView addSubview:footerView];
    self.footerView = footerView;
  }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  cell.textLabel.text = self.dataArray[indexPath.row];
  return cell;
}

#pragma mark - Data Source Loading / Reloading Methods

- (id)chooseRefreshType
{
  if (self.refreshType == REFRESHHead) {
    return self.headerView;
  }else {
    return self.footerView;
  }
}

- (void)reloadTableViewDataSource
{
  /// do sth
  if (self.refreshType == REFRESHFoot) {
    int numberOfOriginalRows = self.dataArray.count;
    for (int i= 0; i < 10; i++) {
      [self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    int numberOfNewRows = self.dataArray.count;
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = numberOfOriginalRows; i < numberOfNewRows; i++) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
      [indexPathArray addObject:indexPath];
    }
    self.footerView.frame = CGRectMake(0, 44 * self.dataArray.count, 320, 44);
    [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfOriginalRows inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }else {
    [self.tableView reloadData];
  }
  self.isLoading = NO;
  [self doneLoadTableViewData];
}

- (void)doneLoadTableViewData
{
  [[self chooseRefreshType] refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView.contentOffset.y > 0) {
    self.refreshType = REFRESHFoot;
  }else {
    self.refreshType = REFRESHHead;
  }
  [[self chooseRefreshType] refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  [[self chooseRefreshType] refreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)refreshTableHeader
{
  self.isLoading = YES;
  [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.5];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading
{
  return self.isLoading;
}

#pragma mark - EGORefreshTableFooterDelegate Methods

- (void)refreshTableFooter
{
  self.isLoading = YES;
  [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.5];
}

- (BOOL)refreshTableFooterDataSourceIsLoading
{
  return self.isLoading;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)dealloc
{
  self.headerView.delegate = nil;
}
@end
