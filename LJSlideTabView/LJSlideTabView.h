//
//  LJSildeTabView.h
//  SideView_objc
//
//  Created by 李敬 on 2017/9/18.
//  Copyright © 2017年 李敬. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJSlideTabView;
@protocol LJSlideTabViewDelegate, LJSlideTabViewDataSource;

@interface LJSlideTabView : UIView

@property(nonatomic, assign, readonly)NSInteger tabCount;

@property(nonatomic, assign)NSInteger currentTabIndex;



/* 顶部的 TabView 的高度 */
@property(nonatomic, assign)CGFloat tabViewHeight;

/* 顶部的 TabView 里每个 Item 的属性 */
@property(nonatomic, strong)UIColor *tabItemColorDefault;
@property(nonatomic, strong)UIColor *tabItemColorHightlight;
@property(nonatomic, strong)UIFont *tabItemFont;
@property(nonatomic, strong)NSArray *tabItemTitles;

/* tabView 中被选中的的 Item 下放的那个指示器的属性 */
@property(nonatomic, assign)float slideViewScale;
@property(nonatomic, assign)CGFloat slideViewHeight;
@property(nonatomic, strong)UIColor *slideViewColor;


@property(nonatomic, weak)id<LJSlideTabViewDelegate> delegate;
@property(nonatomic, weak)id<LJSlideTabViewDataSource> dataSource;

-(instancetype)initWithFrame:(CGRect)frame andTabCount:(NSInteger)tabCount;

@end


@protocol LJSlideTabViewDelegate <NSObject>
@optional
/**
 在第一页向右滑动，常用与响应 pop 事件
 */
-(void)slideTabViewDidRightSlipAtFirstPage;

/**
 在最后一页向左滑动，怎么使用就任由您想象了
 */
-(void)slideTabViewDidLeftSlipAtLastPage;


-(void)slideTabView:(LJSlideTabView *)slideTabView willShowDisplayView:(NSInteger) tabIndex;
-(void)slideTabView:(LJSlideTabView *)slideTabView didShowingDisplayView:(UIView *) displayView;



@end

@protocol  LJSlideTabViewDataSource <NSObject>
@required
-(UIView *)slideTabView:(LJSlideTabView *)slideTabView viewAtTabIndex:(NSInteger) tabIndex;


@end


