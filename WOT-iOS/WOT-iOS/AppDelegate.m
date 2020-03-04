//
//  AppDelegate.m
//  WOT-iOS
//
//  Created on 6/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "AppDelegate.h"

#import "WOTDrawerViewController.h"
#import "WOTApplicationDefaults.h"
#import "NSTimer+BlocksKit.h"

@interface AppDelegate ()

@property (nonatomic, strong) WOTDrawerViewController *wotDrawerViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [WOTApplicationDefaults registerRequests];
    [WOTApplicationDefaults registerDefaultSettings];
    
    WOTWebHostConfiguration *hostConfig = [[WOTWebHostConfiguration alloc] init];
    [WOTRequestExecutor sharedInstance].hostConfiguration = hostConfig;

    [self initSessionTimer];
    
    self.wotDrawerViewController = [[WOTDrawerViewController alloc] initWithMenu];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.wotDrawerViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initSessionTimer {
    [[WOTSessionManager sharedInstance] invalidateTimer:^NSTimer *(NSTimeInterval interval) {
        NSTimer *timer = [NSTimer bk_scheduledTimerWithTimeInterval:interval block:^(NSTimer *timer) {

            [WOTSessionManager logout];
        } repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        return timer;
    }];
}

@end
