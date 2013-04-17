//
//  PullViewController.m
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import "PullViewController.h"

#define PULL  @"上拉刷新"
#define RELEASE @"好了松手啦"
#define LOADING @"加载中..."

@interface PullViewController ()
@end

@implementation PullViewController

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
  self.isLoading = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFootView
{
  UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * self.dataArray.count, 320, 44)];
  NSLog(@"%f",footView.frame.origin.y);
  footView.backgroundColor = [UIColor clearColor];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  label.backgroundColor = [UIColor clearColor];
  label.textAlignment = NSTextAlignmentCenter;
  
  [footView addSubview:label];
  [self.tableView addSubview:footView];
  self.footLable = label;
  self.footView = footView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (self.isLoading == NO) {
    float offSet = scrollView.contentSize.height - scrollView.frame.size.height;
    if (scrollView.contentOffset.y > offSet + 44){
      self.footLable.text = RELEASE;
    }else if (offSet < scrollView.contentOffset.y < offSet + 44) {
      self.footLable.text = PULL;
    }
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  float offSet = scrollView.contentSize.height - scrollView.frame.size.height;
  if (scrollView.contentOffset.y > offSet + 44){
    [self startLoading];
  }
}

- (void)startLoading
{
  self.isLoading = YES;
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
  self.footLable.text = LOADING;
  [UIView commitAnimations];
  [self refresh];
}

- (void)stopLoading
{
  self.isLoading = NO;
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(loadingCompleted)];
  self.tableView.contentInset = UIEdgeInsetsZero;
  [UIView commitAnimations];
  
}

- (void)loadingCompleted
{
  self.footLable.text = PULL;
  self.footView.frame = CGRectMake(0, self.tableView.contentSize.height, 320, 44);
}

- (void)refresh
{
  
}

@end
