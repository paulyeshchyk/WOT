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
#import "WOTSessionManager.h"

@interface AppDelegate () <WOTHostConfigurationOwner, WOTAppDelegateProtocol>

@property (nonatomic, strong) WOTDrawerViewController *wotDrawerViewController;

@end


@implementation AppDelegate
@synthesize hostConfiguration;
@synthesize appManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    id<LogInspectorProtocol> logInspector = [[LogInspector alloc] init];
    [logInspector objcOnlyAddpriority: 0];
    [logInspector objcOnlyAddpriority: 1];
    [logInspector objcOnlyAddpriority: 2];
    [logInspector objcOnlyAddpriority: 3];

    id<WOTRequestCoordinatorProtocol> requestCoordinator = [[WOTRequestCoordinator alloc] init];

    id<WOTHostConfigurationProtocol> hostConfiguration = [[WOTWebHostConfiguration alloc] init];

    id<WOTRequestManagerProtocol, WOTRequestListenerProtocol> requestManager = [[WOTRequestManager alloc] initWithRequestCoordinator:requestCoordinator hostConfiguration:hostConfiguration];
    
    id<WOTWebSessionManagerProtocol> sessionManager = [[WOTWebSessionManager alloc] init];
    
    id<WOTCoredataProviderProtocol> coreDataProvider = [[WOTTankCoreDataProvider alloc] init];

    self.appManager = [WOTPivotAppManager sharedInstance];
    self.appManager.hostConfiguration = hostConfiguration;
    self.appManager.requestManager = requestManager;
    self.appManager.requestListener = requestManager;
    self.appManager.sessionManager = sessionManager;
    self.appManager.logInspector = logInspector;
    self.appManager.coreDataProvider = coreDataProvider;

    [AppDefaults registerRequestsFor:requestCoordinator];
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
            
            [WOTSessionManager logoutWithRequestManager:self->appManager.requestManager];
        } repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        return timer;
    }];
}

@end
