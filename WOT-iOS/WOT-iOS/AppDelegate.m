//
//  AppDelegate.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "AppDelegate.h"

#import "WOTDrawerViewController.h"
#import "WOTApplicationDefaults.h"
#import "WOTApplicationStartupRequests.h"
#import "NSTimer+BlocksKit.h"

@interface WOTWEBHostConfiguration: NSObject<WEBHostConfiguration>
@end

@implementation WOTWEBHostConfiguration

- (NSString *)applicationID {
    return WOT_VALUE_APPLICATION_ID_EU;
}

- (NSString *)host {
    return [WOTApplicationDefaults host];
}

- (NSString *)scheme {
    return [WOTApplicationDefaults scheme];
}

@end


@interface AppDelegate ()

@property (nonatomic, strong) WOTDrawerViewController *wotDrawerViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [WOTApplicationDefaults registerRequests];
    [WOTApplicationDefaults registerDefaultSettings];
    
    WOTWEBHostConfiguration *hostConfig = [[WOTWEBHostConfiguration alloc] init];
    [[WOTRequestExecutor sharedInstance] setHostConfiguration:hostConfig];


    [WOTApplicationStartupRequests executeAllStartupRequests];

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
