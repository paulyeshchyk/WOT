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
#import "Tanks.h"


NSInteger const WOTRequestLoginId = 1;
NSInteger const WOTRequestSaveSessionId = 2;
NSInteger const WOTRequestLogoutId = 3;
NSInteger const WOTRequestClearSessionId = 4;
NSInteger const WOTWEBRequestTanksId = 5;

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

        UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        UIViewController *presentedViewController = [[rootViewController.presentedViewController childViewControllers] firstObject];
        if ([presentedViewController isKindOfClass:[WOTLoginViewController class]]){

            WOTLoginViewController *loginController = (WOTLoginViewController *)presentedViewController;
            loginController.request = request;
            [loginController reloadData];
            
        } else {
        
        
            WOTLoginViewController *loginController = [[WOTLoginViewController alloc] initWithNibName:@"WOTLoginViewController" bundle:nil];
            loginController.request = request;
            loginController.redirectUrlPath = json[WOT_KEY_REDIRECT_URI];
            [loginController setCallback:^(NSError *error, NSString *userID, NSString *access_token, NSString *account_id, NSNumber *expires_at){
                
                NSMutableDictionary *args =[[NSMutableDictionary alloc] init];
                if (error) args[@"error"]=error;
                if (userID) args[@"userId"]=userID;
                if (access_token) args[@"access_token"]=access_token;
                if (account_id) args[@"account_id"]=account_id;
                if (expires_at) args[@"expires_at"]=expires_at;

                [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestSaveSessionId args:args];
                
                [rootViewController dismissViewControllerAnimated:YES completion:NULL];
            }];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
            
            [rootViewController presentViewController:nav animated:YES completion:NULL];
        }
        
    } forRequestId:WOTRequestLoginId];
    
    /**
     * Logout
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestLogout class] forRequestId:WOTRequestLogoutId];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    } forRequestId:WOTRequestLogoutId];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestClearSessionId args:nil];
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLoginId args:nil];
        
    } forRequestId:WOTRequestLogoutId];
    
    /**
     * Save Sassion
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTSaveSessionRequest class] forRequestId:WOTRequestSaveSessionId];

    /**
     * Clear Sassion
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTClearSessionRequest class] forRequestId:WOTRequestClearSessionId];

    
    
    /**
     * Tanks
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestTanks class] forRequestId:WOTWEBRequestTanksId];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    } forRequestId:WOTWEBRequestTanksId];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
        NSDictionary *tanksDictionary = json[@"data"];

        NSArray *tanksArray = [tanksDictionary allKeys];
        
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
        for (NSString *key in tanksArray) {
        
            NSDictionary *tankJSON = tanksDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tank_id == %@",tankJSON[@"tank_id"]];
            Tanks *tank = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tank fillPropertiesFromDictioary:tankJSON];
            
            
        }
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }

    } forRequestId:WOTWEBRequestTanksId];
    
}


@end
