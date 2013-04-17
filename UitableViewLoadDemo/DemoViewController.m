//
//  DemoViewController.m
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
@end

@implementation DemoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Pull Demon";
  NSMutableArray *array = [NSMutableArray array];
  for (int i= 0; i < 10; i++) {
    [array addObject:[NSString stringWithFormat:@"%d",i]];
  }
  self.dataArray = array;
  [self addFootView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)refresh
{
  [self performSelector:@selector(addData) withObject:nil afterDelay:1];
}

- (void)addData
{
  for (int i= 10; i < 20; i++) {
    [self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
  }
  self.footLable.text = @"";
  [self.tableView reloadData];
  [self stopLoading];
}

@end
