//
//  FirstDemoViewController.m
//  LJSlideTabView
//
//  Created by 李敬 on 2017/9/20.
//  Copyright © 2017年 mono. All rights reserved.
//

#import "FirstDemoViewController.h"
#import "LJSlideTabView.h"
@interface FirstDemoViewController ()<LJSlideTabViewDelegate, LJSlideTabViewDataSource>
@property(nonatomic, strong)LJSlideTabView *slideTabView;
@end

@implementation FirstDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _slideTabView = [[LJSlideTabView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) andTabCount:4];
    _slideTabView.delegate = self;
    _slideTabView.dataSource = self;
    _slideTabView.tabItemTitles = @[@"1",@"2",@"3",@"4"];
    [self.view addSubview:_slideTabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideTabView DataSource
-(UIView *)slideTabView:(LJSlideTabView *)slideTabView viewAtTabIndex:(NSInteger)tabIndex{
    if (tabIndex == 0) {
        UIScrollView *scrollView = [UIScrollView new];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
        label.text = @"first page";
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 700, 100, 20)];
        label2.text = @"first page";
        
        [scrollView addSubview:label];
        [scrollView addSubview:label2];
        scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000);
        return scrollView;
        
    } else {
        UIView *view = [UIView new];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
        label.text = [NSString stringWithFormat:@"page index is :%li",(long)tabIndex];
        [view addSubview:label];
        return view;
    }
}

#pragma mark - SlideTabView Delegate
-(void)slideTabViewDidRightSlipAtFirstPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)slideTabView:(LJSlideTabView *)slideTabView didShowingDisplayView:(UIView *)displayView{
    NSLog(@"这里可以用来关掉菊花，或对 view 操作");
}

-(void)slideTabView:(LJSlideTabView *)slideTabView willShowDisplayView:(NSInteger)tabIndex{
    NSLog(@"这里可以用来转起菊花");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
