//
//  TestWOTRequestExecutor.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/26/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "WOTRequestExecutor.h"

@interface TestWOTRequestExecutor : XCTestCase

@end

@implementation TestWOTRequestExecutor

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSharedInstanceIsNotNull {
    
    WOTRequestExecutor *sharedInstance = [WOTRequestExecutor sharedInstance];
    XCTAssertNotNil(sharedInstance);
}

- (void)testSharedInstanceInitiallyHasNoPendingRequests {
    
    WOTRequestExecutor *sharedInstance = [WOTRequestExecutor sharedInstance];
    XCTAssertEqual(sharedInstance.pendingRequestsCount, 0);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
