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
    [self.view addSubview:headerView];
    self.headerView = headerView;
  }
  
  if (self.footerView == nil) {
    RefreshTableFooterView *footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0, self.dataArray.count * 44, 320, self.tableView.bounds.size.height)];
    footerView .delegate = self;
    [self.tableView addSubview:footerView ];
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
    for (int i= 0; i < 10; i++) {
      [self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.tableView reloadData];
    self.footerView.frame = CGRectMake(0, self.tableView.contentSize.height, 320, 44);
  }else {
    [self.tableView reloadData];
  }
  self.isLoading = YES;
}

- (void)doneLoadTableViewData
{
  self.isLoading = NO;
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
  [self reloadTableViewDataSource];
  [self performSelector:@selector(doneLoadTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading
{
  return self.isLoading;
}

#pragma mark - EGORefreshTableFooterDelegate Methods

- (void)refreshTableFooter
{
  //[self reloadTableViewDataSource];
  [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:2.0];
  [self performSelector:@selector(doneLoadTableViewData) withObject:nil afterDelay:2.0];
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
