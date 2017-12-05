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
    
    NSArray *titles = @[@"要闻",@"推荐",@"滚动",@"机会",@"同顺号",@"自选",@"大盘",@"操盘必读"];
    
    _slideTabView = [[LJSlideTabView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) andTabCount:titles.count];
    _slideTabView.tabItemTitles = titles;
    _slideTabView.dataSource = self;
    
    _slideTabView.tabViewHeight = 50;
    _slideTabView.tabItemBackGroudColor = UIColor.redColor;
    _slideTabView.slideViewColor = UIColor.whiteColor;
    _slideTabView.tabItemTextColorDefault = UIColor.whiteColor;
    _slideTabView.tabItemTextColorHighlight = UIColor.whiteColor;
    _slideTabView.tabItemFont = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_slideTabView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

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
