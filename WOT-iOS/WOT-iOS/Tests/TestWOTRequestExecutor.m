//
//  TestWOTRequestExecutor.m
//  WOT-iOS
//
//  Created on 8/26/15.
//  Copyright (c) 2015. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <WOTPivot/WOTPivot.h>

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
    
//    WOTRequestManager *sharedInstance = [WOTRequestManager sharedInstance];
//    XCTAssertNotNil(sharedInstance);
}

- (void)testSharedInstanceInitiallyHasNoPendingRequests {
    
//    WOTRequestManager *sharedInstance = [WOTRequestManager sharedInstance];
//    XCTAssertEqual(sharedInstance.pendingRequestsCount, 0);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
