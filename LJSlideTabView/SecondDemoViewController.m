//
//  SecondDemoViewController.m
//  LJSlideTabView
//
//  Created by 李敬 on 2017/10/6.
//  Copyright © 2017年 mono. All rights reserved.
//

#import "SecondDemoViewController.h"
#import "LJSlideTabView.h"

@interface SecondDemoViewController ()<LJSlideTabViewDataSource>
@property(nonatomic, strong) LJSlideTabView *slideTabView;

@end

@implementation SecondDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _slideTabView = [[LJSlideTabView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) andTabCount:10];
    _slideTabView.dataSource = self;
    [self.view addSubview:_slideTabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)slideTabView:(LJSlideTabView *)slideTabView viewAtTabIndex:(NSInteger)tabIndex{
    UIView *view = [UIView new];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    label.text = [NSString stringWithFormat:@"page index is :%li", (long) tabIndex];
    [view addSubview:label];
    return view;
}

@end
