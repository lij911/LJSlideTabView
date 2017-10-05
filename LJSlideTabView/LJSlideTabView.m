//
//  LJSlideTabView.m
//  LJSlideTabView
//
//  Created by 李敬 on 2017/9/18.
//  Copyright © 2017年 李敬. All rights reserved.
//

#import "LJSlideTabView.h"

/* TabView 的高度*/
static const CGFloat kTabViewHeightDefault = 30.0;
/* 滑动指示器 SlideView 的占整个 Tab 的比例 */
static const float kSlideViewScale = 0.3;
/* 滑动指示器 SlideView 的高度 */
static const CGFloat kSlideViewHeightDefault = 2.5;

struct {

    unsigned int slideTabViewDidRightSlipAtFirstPage : 1;
    unsigned int slideTabViewDidLeftSlipAtLastPage : 1;

    unsigned int willShowDisplayView : 1;
    unsigned int didShowingDisplayView : 1;

} _delegateFlags;

struct {

    unsigned int needLayoutTabItems : 1;
    unsigned int needLayoutDisplayView : 1;

} _layoutFlags;

@interface LJSlideTabView () <UIScrollViewDelegate>

@property(nonatomic) CGRect myFrame;

@property(nonatomic, strong) UIScrollView *mainScrollView;

@property(nonatomic, strong) NSMutableDictionary *disPlayViews;

@property(nonatomic, strong) NSMutableArray *tabItems;

@property(nonatomic, strong) UIScrollView *tabScrollView;

@property(nonatomic, strong) UIView *slideView;

@end

@implementation LJSlideTabView

- (void)drawRect:(CGRect)rect {
    [self setupView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andTabCount:2];
}

- (instancetype)initWithFrame:(CGRect)frame andTabCount:(NSInteger)tabCount {
    self = [super initWithFrame:frame];
    if (self) {
        _myFrame = frame;
        _tabCount = tabCount;
        _currentTabIndex = 0;
        _tabViewHeight = kTabViewHeightDefault;
        _slideViewScale = kSlideViewScale;
        _slideViewHeight = kSlideViewHeightDefault;
        _disPlayViews = [NSMutableDictionary dictionary];
        _tabItemFont = [UIFont systemFontOfSize:14];
        _slideViewColor = [UIColor colorWithRed:239 / 256.0 green:154 / 256.0 blue:66 / 256.0 alpha:1];
        _tabItemColorDefault = [UIColor colorWithRed:153 / 256.0 green:153 / 256.0 blue:153 / 256.0 alpha:1];
        _tabItemColorHighlight = [UIColor colorWithRed:12 / 256.0 green:78 / 256.0 blue:159 / 256.0 alpha:1];
    }
    return self;
}

#pragma mark - layout

- (void)setupView {
    NSAssert(_tabCount >= 2 && _tabCount < 6, @"ilegal count!");

    if (_currentTabIndex < 0 || _currentTabIndex >= _tabCount) {
        _currentTabIndex = 0;
    }

    if (_tabViewHeight <= 0 || _tabViewHeight > _myFrame.size.height) {
        _tabViewHeight = kTabViewHeightDefault;
    }
    CGFloat width = _myFrame.size.width / _tabCount;

    [self addSubview:self.mainScrollView];
    [self addSubview:self.tabScrollView];
    [_tabScrollView addSubview:self.slideView];

    // 对可能修改过的属性重新赋值
    _slideView.backgroundColor = _slideViewColor;
    _slideView.frame = CGRectMake(width * (_currentTabIndex + (1 - _slideViewScale) / 2), _tabViewHeight - _slideViewHeight, width * _slideViewScale, _slideViewHeight);
    _tabScrollView.frame = CGRectMake(0, 0, _myFrame.size.width, _tabViewHeight);

    //
    if (!_tabItems) {
        [self setupTabItems];
    } else if (_layoutFlags.needLayoutTabItems) {
        [self relayoutTabItems];
    }

    [self setupDisplayViewAtTabIndex:_currentTabIndex];
    if (_layoutFlags.needLayoutDisplayView) {
        [self relayoutDisplayView];
    }


}

- (void)setupTabItems {
    _tabItems = [NSMutableArray array];
    CGFloat width = _myFrame.size.width / _tabCount;

    for (NSUInteger i = 0; i < _tabCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, _tabViewHeight)];
        btn.tag = i;
        btn.titleLabel.font = _tabItemFont;
        btn.userInteractionEnabled = YES;
        if (_tabItemTitles) {
            [btn setTitle:_tabItemTitles[i] forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"Button" forState:UIControlStateNormal];
        }
        if (i == _currentTabIndex) {
            [btn setTitleColor:_tabItemColorHighlight forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:_tabItemColorDefault forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(switchTabView:) forControlEvents:UIControlEventTouchUpInside];
        [_tabItems addObject:btn];
        [_tabScrollView addSubview:btn];
    }
}

- (void)relayoutTabItems {
    [_tabItems enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIButton *btn = obj;
        CGRect frame = btn.frame;
        frame.size.height = _tabViewHeight;
        btn.frame = frame;
        btn.titleLabel.font = _tabItemFont;
        [btn setTitle:_tabItemTitles[idx] forState:UIControlStateNormal];
        if (idx == _currentTabIndex) {
            [btn setTitleColor:_tabItemColorHighlight forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:_tabItemColorDefault forState:UIControlStateNormal];
        }
    }];
}

- (void)setupDisplayViewAtTabIndex:(NSInteger)tabIndex {
    if (![_disPlayViews objectForKey:@(tabIndex)]) {
        UIView *displayView = [_dataSource slideTabView:self viewAtTabIndex:tabIndex];
        NSParameterAssert(displayView);
        displayView.frame = CGRectMake(tabIndex * _myFrame.size.width, _tabViewHeight, _myFrame.size.width, _myFrame.size.height - _tabViewHeight);
        displayView.tag = tabIndex;
        [self.mainScrollView addSubview:displayView];
        [_disPlayViews setObject:displayView forKey:@(tabIndex)];
        if (_delegateFlags.didShowingDisplayView) {
            [_delegate slideTabView:self didShowingDisplayView:displayView];
        }
    } else {
        if (_delegateFlags.didShowingDisplayView) {
            [_delegate slideTabView:self didShowingDisplayView:[_disPlayViews objectForKey:@(tabIndex)]];
        }
    }
}

- (void)relayoutDisplayView {
    [_disPlayViews enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        UIView *displayView = obj;
        displayView.frame = CGRectMake([key integerValue] * _myFrame.size.width, _tabViewHeight, _myFrame.size.width, _myFrame.size.height - _tabViewHeight);
    }];
}

#pragma mark -


- (void)switchTabWithNextTabIndex:(NSInteger)nextTabIndex {

    if (nextTabIndex != _currentTabIndex) {

        if (_delegateFlags.willShowDisplayView) {
            [_delegate slideTabView:self willShowDisplayView:nextTabIndex];
        }

        [self setupDisplayViewAtTabIndex:nextTabIndex];

        UIButton *btn = _tabItems[_currentTabIndex];
        [btn setTitleColor:_tabItemColorDefault forState:UIControlStateNormal];
        btn = _tabItems[nextTabIndex];
        [btn setTitleColor:_tabItemColorHighlight forState:UIControlStateNormal];
        _currentTabIndex = nextTabIndex;

    }

}

#pragma mark - Sync ScrollView


#pragma mark - Action Response

- (void)switchTabView:(UIButton *)sender {
    if (labs(_currentTabIndex - sender.tag) < 2) {
        [_mainScrollView setContentOffset:CGPointMake(sender.tag * _myFrame.size.width, 0) animated:YES];
        [self switchTabWithNextTabIndex:sender.tag];
    } else {
        [_mainScrollView setContentOffset:CGPointMake(sender.tag * _myFrame.size.width, 0) animated:NO];
        [self switchTabWithNextTabIndex:sender.tag];
    }
}


#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger nextTabIndex = _mainScrollView.contentOffset.x / _myFrame.size.width;
    [self switchTabWithNextTabIndex:nextTabIndex];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = _slideView.frame;
    frame.origin.x = (scrollView.contentOffset.x / _tabCount) + (_myFrame.size.width / _tabCount) * (1 - _slideViewScale) / 2;
    _slideView.frame = frame;
    if (_currentTabIndex == 0 && scrollView.contentOffset.x < -_myFrame.size.width * 0.2) {
        if (_delegateFlags.slideTabViewDidRightSlipAtFirstPage) {
            [_delegate slideTabViewDidRightSlipAtFirstPage];
        }
    } else if (_currentTabIndex == (_tabCount - 1) && scrollView.contentOffset.x > _myFrame.size.width * 0.2) {
        if (_delegateFlags.slideTabViewDidLeftSlipAtLastPage) {
            [_delegate slideTabViewDidLeftSlipAtLastPage];
        }
    }
}

#pragma mark - setters

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    _delegateFlags.slideTabViewDidRightSlipAtFirstPage = (unsigned int) [delegate respondsToSelector:@selector(slideTabViewDidRightSlipAtFirstPage)];
    _delegateFlags.slideTabViewDidLeftSlipAtLastPage = (unsigned int) [delegate respondsToSelector:@selector(slideTabViewDidLeftSlipAtLastPage)];
    _delegateFlags.willShowDisplayView = (unsigned int) [delegate respondsToSelector:@selector(slideTabView:willShowDisplayView:)];
    _delegateFlags.didShowingDisplayView = (unsigned int) [delegate respondsToSelector:@selector(slideTabView:didShowingDisplayView:)];

}

- (void)setDataSource:(id <LJSlideTabViewDataSource>)dataSource {
    _dataSource = dataSource;
}

- (void)setCurrentTabIndex:(NSInteger)currentTabIndex {
    [self switchTabWithNextTabIndex:currentTabIndex];
}

- (void)setTabItemTitles:(NSArray *)tabItemTitles {
    NSParameterAssert([tabItemTitles count] == _tabCount);
    _tabItemTitles = tabItemTitles;
    _layoutFlags.needLayoutTabItems = true;
}

- (void)setTabItemColorHighlight:(UIColor *)tabItemColorHighlight {
    _tabItemColorHighlight = tabItemColorHighlight;
    _layoutFlags.needLayoutTabItems = true;
}

- (void)setTabItemColorDefault:(UIColor *)tabItemColorDefault {
    _tabItemColorDefault = tabItemColorDefault;
    _layoutFlags.needLayoutTabItems = true;
}

- (void)setTabItemFont:(UIFont *)tabItemFont {
    _tabItemFont = tabItemFont;
    _layoutFlags.needLayoutTabItems = true;
}

- (void)setTabViewHeight:(CGFloat)tabViewHeight {
    _tabViewHeight = tabViewHeight;
    _layoutFlags.needLayoutDisplayView = true;
}

#pragma mark - lazy init

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.contentSize = CGSizeMake(_myFrame.size.width * _tabCount, _myFrame.size.height);
        _mainScrollView.backgroundColor = [UIColor whiteColor];

        _mainScrollView.showsHorizontalScrollIndicator = NO;

        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (UIView *)slideView {
    if (!_slideView) {
        CGFloat width = _myFrame.size.width / _tabCount;
        _slideView = [[UIView alloc] initWithFrame:CGRectMake(width * (_currentTabIndex + (1 - _slideViewScale) / 2), _tabViewHeight - _slideViewHeight, width * _slideViewScale, _slideViewHeight)];
        _slideView.backgroundColor = _slideViewColor;
    }
    return _slideView;
}

- (UIScrollView *)tabScrollView {
    if (!_tabScrollView) {
        CGFloat width = _myFrame.size.width / _tabCount;

        _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _myFrame.size.width, _tabViewHeight)];
        _tabScrollView.contentSize = CGSizeMake(width * _tabCount, _tabViewHeight);

        _tabScrollView.showsHorizontalScrollIndicator = YES;
        _tabScrollView.showsVerticalScrollIndicator = NO;
        _tabScrollView.bounces = NO;

        _tabScrollView.delegate = self;
    }
    return _tabScrollView;
}


@end

