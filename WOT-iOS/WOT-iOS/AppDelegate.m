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

@interface AppDelegate () <WOTHostConfigurationOwner>

@property (nonatomic, strong) WOTDrawerViewController *wotDrawerViewController;

@end


@implementation AppDelegate
@synthesize hostConfiguration;

- (WOTWebHostConfiguration *)hostConfiguration {
    if (hostConfiguration == nil) {
        hostConfiguration = [[WOTWebHostConfiguration alloc] init];
    }
    return hostConfiguration;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [WOTApplicationDefaults registerRequests];
    [WOTApplicationDefaults registerDefaultSettings];
   

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
