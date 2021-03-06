//
//  main.m
//  WOT-iOS
//
//  Created on 6/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char * argv[]) {
    
    BOOL inTests = (NSClassFromString(@"SenTestCase") != nil
                    || NSClassFromString(@"XCTest") != nil);

    if (inTests){

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegateTest class]));
    } else {

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
