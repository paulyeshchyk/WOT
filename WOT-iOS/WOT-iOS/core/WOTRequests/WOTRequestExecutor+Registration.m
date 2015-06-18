//
//  WOTRequestExecutor+Registration.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTRequestExecutor+Registration.h"
#import "WOTWEBRequestLogin.h"
#import "WOTSaveSessionRequest.h"
#import "WOTWEBRequestLogout.h"

#import "WOTLoginViewController.h"
#import "WOTClearSessionRequest.h"
#import "WOTWEBRequestTanks.h"
#import "WOTWEBRequestTankEngines.h"
#import "Tanks.h"
#import "Tankengines.h"
#import "WOTSessionDataProvider.h"
#import "WOTDataProviderTanks.h"
#import "WOTDataProviderTankEngines.h"

@implementation WOTRequestExecutor (Registration)

+ (void)registerRequests {

    /**
     * Login
     **/
    
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerRequestClass:[WOTWEBRequestLogin class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    }];
    
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerRequestJSONCallback:^(NSDictionary *json) {
        
        NSString *location = json[WOT_KEY_DATA][WOT_KEY_LOCATION];
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
            loginController.redirectUrlPath = json[WOT_KEY_REDIRECT_URI];
            [loginController setCallback:^(NSError *error, NSString *userID, NSString *access_token, NSString *account_id, NSNumber *expires_at){
                
                NSMutableDictionary *args =[[NSMutableDictionary alloc] init];
                if (error) args[WOT_KEY_ERROR]=error;
                if (userID) args[WOT_KEY_USER_ID]=userID;
                if (access_token) args[WOT_KEY_ACCESS_TOKEN]=access_token;
                if (account_id) args[WOT_KEY_ACCOUNT_ID]=account_id;
                if (expires_at) args[WOT_KEY_EXPIRES_AT]=expires_at;//@([[NSDate date] timeIntervalSince1970] + 60.0f*0.25f);//

                [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdSaveSession args:args];
                
                [rootViewController dismissViewControllerAnimated:YES completion:NULL];
            }];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
            
            [rootViewController presentViewController:nav animated:YES completion:NULL];
        }
        
    }];
    
    /**
     * Logout
     **/
    
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestClass:[WOTWEBRequestLogout class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    }];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestJSONCallback:^(NSDictionary *json) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WOT_NOTIFICATION_LOGOUT object:nil userInfo:nil];
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdClearSession args:nil];
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdLogin args:nil];
        
    }];
    
    /**
     * Save Sassion
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestClass:[WOTSaveSessionRequest class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestErrorCallback:^(NSError *error) {
        
        [[WOTSessionDataProvider sharedInstance] invalidateTimer];
        
    }];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestJSONCallback:^(NSDictionary *json) {
        
        [[WOTSessionDataProvider sharedInstance] invalidateTimer];
    }];

    /**
     * Clear Sassion
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdClearSession registerRequestClass:[WOTClearSessionRequest class]];

    
    /**
     * Tanks.Tanks
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTanksList registerDataProvider:[[WOTDataProviderTanks alloc] init]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTanksList registerRequestClass:[WOTWEBRequestTanks class]];

    /**
     * Tanks.Engines
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankEnginesList registerRequestClass:[WOTWEBRequestTankEngines class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankEnginesList registerDataProvider:[[WOTDataProviderTankEngines alloc] init]];
    
}


@end
