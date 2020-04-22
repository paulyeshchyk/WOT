//
//  WOTWebSessionManager.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTWebSessionManager: NSObject, WOTWebSessionManagerProtocol {
    @objc
    var appManager: WOTAppManagerProtocol?

    @objc
    func login() {}

    @objc
    func logout() {}
}

class WOTWebSessionClearResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    var appManager: WOTAppManagerProtocol?

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) -> CoreDataStoreProtocol {
        fatalError("should be implemented")
    }
}

class WOTWebSessionSaveResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    var appManager: WOTAppManagerProtocol?

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) -> CoreDataStoreProtocol {
        fatalError("should be implemented")
        /*
         ^(NSData *binary, NSError *error) {

         [[WOTSessionManager sharedInstance] invalidateTimer:^NSTimer *(NSTimeInterval interval) {
         NSTimer *timer = [NSTimer bk_scheduledTimerWithTimeInterval:interval block:^(NSTimer *timer) {

         [WOTSessionManager logoutWithRequestManager:manager.requestManager];
         } repeats:NO];
         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
         return timer;
         }];

         }
         */
    }
}

class WOTWebSessionLoginResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    var appManager: WOTAppManagerProtocol?

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) )  -> CoreDataStoreProtocol {
        fatalError("should be implemented")
        /*
         ^(NSData *binary, NSError *error) {

         if (error){

         [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
         return;
         }

         [binary parseAsJSON:^(NSDictionary * _Nullable data) {

         NSString *location = data[WGJsonFields.data][WOT_KEY_LOCATION];
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:location]];

         UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
         UIViewController *presentedViewController = [[rootViewController.presentedViewController childViewControllers] firstObject];
         if ([presentedViewController isKindOfClass:[WOTLoginViewController class]]){

         WOTLoginViewController *loginController = (WOTLoginViewController *)presentedViewController;
         loginController.request = request;
         [loginController reloadData];

         } else {

         WOTLoginViewController *loginController = [[WOTLoginViewController alloc] initWithNibName:NSStringFromClass([WOTLoginViewController class]) bundle:nil];
         loginController.request = request;
         loginController.redirectUrlPath = data[WOTApiKeys.redirectUri];
         [loginController setCallback:loginCallback];

         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];

         [rootViewController presentViewController:nav animated:YES completion:NULL];
         }
         }];

         }

         WOTLoginCallback loginCallback = ^(WOTLogin *wotLogin){

         id<WOTPivotAppManagerProtocol> manager = ((id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate]).appManager;
         id<WOTRequestCoordinatorProtocol> requestCoordinator = manager.requestManager.requestCoordinator;

         NSDictionary *argsDictionary = [wotLogin asDictionary];
         WOTRequestArguments *args = [[WOTRequestArguments alloc] init:argsDictionary];

         id<WOTHostConfigurationOwner> hostOwner = (id<WOTHostConfigurationOwner>) [UIApplication sharedApplication].delegate;
         id<WOTRequestProtocol> request = [requestCoordinator createRequestForRequestId:WOTRequestIdSaveSession];
         request.hostConfiguration = hostOwner.hostConfiguration;
         [request start:args];

         UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
         [rootViewController dismissViewControllerAnimated:YES completion:NULL];
         };

         */
    }
}

class WOTWebSessionLogoutResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    var appManager: WOTAppManagerProtocol?

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) )  -> CoreDataStoreProtocol {
        fatalError("should be implemented")
        /*
         ^(NSData *binary, NSError *error) {

         if (error){

         [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
         } else {

         [[NSNotificationCenter defaultCenter] postNotificationName:WOT_NOTIFICATION_LOGOUT object:nil userInfo:nil];

         id<WOTRequestProtocol> clearSessionRequest = [coordinator createRequestForRequestId:WOTRequestIdClearSession];
         clearSessionRequest.hostConfiguration = manager.hostConfiguration;
         [clearSessionRequest start: [[WOTRequestArguments alloc] init]];

         id<WOTRequestProtocol> loginRequest = [coordinator createRequestForRequestId:WOTRequestIdLogin];
         loginRequest.hostConfiguration = manager.hostConfiguration;
         [loginRequest start: [[WOTRequestArguments alloc] init] ];
         }

         }
         */
    }
}
