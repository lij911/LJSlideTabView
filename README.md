# LJSlideTabView
实现顶部 Tab 功能

![demo1](http://blog.glassysky.cn/wp-content/uploads/2017/09/Simulator-Screen-Shot-iPhone-8-2017-09-21-at-16.24.04.png)

* 导入头文件
```

#import "LJSlideTabView.h"

```

* 初始化 SlideTabView

```
    _slideTabView = [[LJSlideTabView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 
    [UIScreen mainScreen].bounds.size.height - 64) andTabCount:4]; 
     _slideTabView.dataSource = self;
    [self.view addSubview:_slideTabView];

```

* 实现 DataSource (Display View)
```
#pragma mark - SlideTabView DataSource
-(UIView *)slideTabView:(LJSlideTabView *)slideTabView viewAtTabIndex:(NSInteger)tabIndex{
    if (tabIndex == 0) {
        UIScrollView *scrollView = [UIScrollView new];
        //不需要设置 frame 
        return scrollView;
        
    } else {
        UIView *view = [UIView new];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
        label.text = [NSString stringWithFormat:@"page index is :%li",(long)tabIndex];
        [view addSubview:label];
        return view;
    }
}
```


* 可以修改的属性
```
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
```
* 可以实现的 Delegate

```
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
```
