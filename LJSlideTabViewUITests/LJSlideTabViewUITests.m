//
//  LJSlideTabViewUITests.m
//  LJSlideTabViewUITests
//
//  Created by 李敬 on 2017/9/20.
//  Copyright © 2017年 mono. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LJSlideTabViewUITests : XCTestCase

@end

@implementation LJSlideTabViewUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"1.普通的Demo"] tap];
    
    [[[[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"First Demo"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeScrollView] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeScrollView].element swipeLeft];
    
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElement *pageIndexIs1Element = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"page index is :1"].element;
    [pageIndexIs1Element swipeLeft];
    
    XCUIElement *pageIndexIs2Element = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"page index is :2"].element;
    [pageIndexIs2Element swipeLeft];
    [[scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"page index is :3"].element swipeRight];
    [pageIndexIs2Element swipeRight];
    [pageIndexIs1Element swipeRight];
    
    XCUIElementQuery *buttonScrollViewsQuery = [app.scrollViews containingType:XCUIElementTypeButton identifier:@"Button"];
    [[[[buttonScrollViewsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:1] tap];
    
    XCUIElement *button = [[[buttonScrollViewsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:2];
    [button tap];
    [[[[buttonScrollViewsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:3] tap];
    [[[[buttonScrollViewsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:0] tap];
    [button tap];
    [app.navigationBars[@"First Demo"].buttons[@"Back"] tap];
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


@end
