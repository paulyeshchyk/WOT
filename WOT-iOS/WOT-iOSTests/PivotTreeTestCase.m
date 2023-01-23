//
//  PivotTreeTestCase.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/31/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WOTPivotTree.h"

@interface PivotTreeTestCase : XCTestCase

@end

@implementation PivotTreeTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialPivotContentSizeShouldBeSizeZero {
 
    WOTPivotTree *tree = [[WOTPivotTree alloc] init];
    CGSize contentSize = tree.contentSize;
    
    XCTAssert(CGSizeEqualToSize(CGSizeZero,contentSize), @"contentSize should be equal to CGSizeZero");
}

@end
