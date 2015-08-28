//
//  WOTWebResponseAdapterLogin.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterLogin.h"
#import "WOTLoginViewController.h"
#import "WOTRequestExecutor.h"

@implementation WOTWebResponseAdapterLogin

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error){
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *location = data[WOT_KEY_DATA][WOT_KEY_LOCATION];
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
        loginController.redirectUrlPath = data[WOT_KEY_REDIRECT_URI];
        [loginController setCallback:loginCallback];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        
        [rootViewController presentViewController:nav animated:YES completion:NULL];
    }
}

WOTLoginCallback loginCallback = ^(WOTLogin *wotLogin){

    NSDictionary *args = [wotLogin asDictionary];
    
    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdSaveSession];
    [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];

    UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:NULL];
};

@end
