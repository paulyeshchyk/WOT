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
#import "WOTSessionDataProvider.h"

@implementation WOTRequestExecutor (Registration)

+ (void)registerRequests {

    /**
     * Login
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestLogin class] forRequestId:WOTRequestIdLogin];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    } forRequestId:WOTRequestIdLogin];
    
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
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
        
    } forRequestId:WOTRequestIdLogin];
    
    /**
     * Logout
     **/
    
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestLogout class] forRequestId:WOTRequestIdLogout];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        
    } forRequestId:WOTRequestIdLogout];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WOT_NOTIFICATION_LOGOUT object:nil userInfo:nil];
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdClearSession args:nil];
        [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdLogin args:nil];
        
    } forRequestId:WOTRequestIdLogout];
    
    /**
     * Save Sassion
     **/
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTSaveSessionRequest class] forRequestId:WOTRequestIdSaveSession];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        
        [[WOTSessionDataProvider sharedInstance] invalidateTimer];
        
    } forRequestId:WOTRequestIdSaveSession];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {
        
        [[WOTSessionDataProvider sharedInstance] invalidateTimer];
    } forRequestId:WOTRequestIdSaveSession];

    /**
     * Clear Sassion
     **/
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTClearSessionRequest class] forRequestId:WOTRequestIdClearSession];

    
    /**
     * Tanks
     **/
    [[WOTRequestExecutor sharedInstance] registerRequestClass:[WOTWEBRequestTanks class] forRequestId:WOTRequestIdTanksList];
    [[WOTRequestExecutor sharedInstance] registerRequestErrorCallback:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    } forRequestId:WOTRequestIdTanksList];
    [[WOTRequestExecutor sharedInstance] registerRequestJSONCallback:^(NSDictionary *json) {

        NSDictionary *tanksDictionary = json[WOT_KEY_DATA];

        NSArray *tanksArray = [tanksDictionary allKeys];
        
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
        for (NSString *key in tanksArray) {
        
            NSDictionary *tankJSON = tanksDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID,tankJSON[WOT_KEY_TANK_ID]];
            Tanks *tank = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tank fillPropertiesFromDictioary:tankJSON];
        }

        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }

    } forRequestId:WOTRequestIdTanksList];
    
}


@end
