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


NSInteger const WOTRequestLoginId = 1;
NSInteger const WOTRequestSaveSessionId = 2;
NSInteger const WOTRequestLogoutId = 3;


@implementation WOTRequestExecutor (Registration)

+ (void)registerRequests {
    
    
    /**
     * Login
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestLogin class] forRequestId:WOTRequestLoginId];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    } forRequestId:WOTRequestLoginId];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
        NSString *location = json[@"data"][@"location"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:location]];

        UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        WOTLoginViewController *loginController = [[WOTLoginViewController alloc] initWithNibName:@"WOTLoginViewController" bundle:nil];
        loginController.request = request;
        loginController.redirectUrlPath = json[@WOT_REDIRECT_URI];
        [loginController setCallback:^(NSError *error, NSString *userID, NSString *access_token, NSString *account_id, NSNumber *expires_at){
            
            NSMutableDictionary *args =[[NSMutableDictionary alloc] init];
            if (error) args[@"error"]=error;
            if (userID) args[@"userId"]=userID;
            if (access_token) args[@"access_token"]=access_token;
            if (account_id) args[@"account_id"]=account_id;
            if (expires_at) args[@"expires_at"]=expires_at;

            [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestSaveSessionId args:args];
            
            [navigationController dismissViewControllerAnimated:YES completion:NULL];
        }];
        [navigationController presentViewController:loginController animated:YES completion:NULL];
        
    } forRequestId:WOTRequestLoginId];

    /**
     * Save Sassion
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTSaveSessionRequest class] forRequestId:WOTRequestSaveSessionId];

    
    /**
     * Logout
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestLogout class] forRequestId:WOTRequestLogoutId];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    } forRequestId:WOTRequestLogoutId];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
        
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLoginId args:nil];
        
    } forRequestId:WOTRequestLogoutId];
}


@end
