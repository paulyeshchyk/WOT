//
//  WOTApplicationDefaults.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTApplicationDefaults.h"

#import <WOTData/WOTData.h>
#import <WOTData/WOTData-Swift.h>
#import <WOTPivot/WOTPivot.h>

#import "WOTTankListSettingsDatasource.h"
#import "NSTimer+BlocksKit.h"
#import "WOTLoginViewController.h"

@implementation WOTApplicationDefaults

+ (void)registerDefaultSettings {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];

    NSString *entityName = NSStringFromClass([ListSetting class]);
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_ORDERBY ascending:YES]]];
    NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultController performFetch:&error];
    
#warning will recreate objects if user has deleted everything
    if ([[fetchedResultController fetchedObjects] count] == 0) {
        
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOTApiKeys.nation ascending:NO orderBy:0 callback:NULL];
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOTApiKeys.type ascending:YES orderBy:1 callback:NULL];
        
        
        [WOTTankListSettingsDatasource context:context createGroupBySettingForKey:WOTApiKeys.nation ascending:YES orderBy:0 callback:NULL];
        
        [WOTTankListSettingsDatasource context:context createFilterBySettingForKey:WOTApiKeys.tier value:@"6" callback:NULL];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }
    
}

+ (void)registerRequests {

    /**
     * Login
     **/
//    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerRequestClass:[WOTWEBRequestLogin class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerRequestCallback:^(id data, NSError *error, NSData *binary) {

        if (error){

            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
            return;
        }

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

    /**
     * Logout
     **/
//    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestClass:[WOTWEBRequestLogout class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestCallback:^(id data, NSError *error, NSData *binary) {
        
        if (error){
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WOT_NOTIFICATION_LOGOUT object:nil userInfo:nil];
            WOTRequest *clearSessionRequest = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdClearSession];
            [[WOTRequestExecutor sharedInstance] runRequest:clearSessionRequest withArgs:nil];
            
            WOTRequest *loginRequest = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdLogin];
            [[WOTRequestExecutor sharedInstance] runRequest:loginRequest withArgs:nil];
        }
        
    }];

    /**
     * Save Sassion
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestClass:[WOTSaveSessionRequest class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestCallback:^(id data, NSError *error, NSData *binary) {
        
        [[WOTSessionManager sharedInstance] invalidateTimer:^NSTimer *(NSTimeInterval interval) {
            NSTimer *timer = [NSTimer bk_scheduledTimerWithTimeInterval:interval block:^(NSTimer *timer) {

                [WOTSessionManager logout];
            } repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            return timer;
        }];
        
    }];

    /**
     * Clear Sassion
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdClearSession registerRequestClass:[WOTClearSessionRequest class]];

    /**
     * Tanks.Chassis
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankChassis registerRequestClass:[WOTWEBRequestTankChassis class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankChassis registerDataAdapterClass:[WOTWebResponseAdapterChassis class]];
    
    /**
     * Tanks.Turrets
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankTurrets registerRequestClass:[WOTWEBRequestTankTurrets class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankTurrets registerDataAdapterClass:[WOTWebResponseAdapterTurrets class]];
    
    /**
     * Tanks.Guns
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankGuns registerRequestClass:[WOTWEBRequestTankGuns class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankGuns registerDataAdapterClass:[WOTWebResponseAdapterGuns class]];
    
    /**
     * Tanks.Radios
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankRadios registerRequestClass:[WOTWEBRequestTankRadios class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankRadios registerDataAdapterClass:[WOTWebResponseAdapterRadios class]];
    
    /**
     * Tanks.Engines
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankEngines registerRequestClass:[WOTWEBRequestTankEngines class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankEngines registerDataAdapterClass:[WOTWebResponseAdapterEngines class]];

    /**
     * Tanks.Vehicles
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankVehicles registerRequestClass:[WOTWEBRequestTankVehicles class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankVehicles registerDataAdapterClass:[VehiclesAdapter class]];
    
    /**
     * Tanks.Modules
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdModulesTree registerRequestClass:[WOTWEBRequestModulesTree class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdModulesTree registerDataAdapterClass:[WOTWebResponseAdapterModulesTree class]];

    /**
     * Tanks.Profile
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankProfile registerRequestClass:[WOTWEBRequestTankProfile class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankProfile registerDataAdapterClass:[WOTWebResponseAdapterProfile class]];
    
}

WOTLoginCallback loginCallback = ^(WOTLogin *wotLogin){

    NSDictionary *argsDictionary = [wotLogin asDictionary];
    WOTRequestArguments *args = [[WOTRequestArguments alloc] init:argsDictionary];

    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdSaveSession];
    [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];

    UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:NULL];
};


static NSString *WOTWEBRequestDefaultLanguage;

+ (void)setLanguage:(NSString *)language {
    
    WOTWEBRequestDefaultLanguage = language;
    if (language) {
        
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:WOT_USERDEFAULTS_LOGIN_LANGUAGE];
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:WOT_USERDEFAULTS_LOGIN_LANGUAGE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *)language {
    
    if ([WOTWEBRequestDefaultLanguage length] == 0){
        
        NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:WOT_USERDEFAULTS_LOGIN_LANGUAGE];
        if ([language length] == 0){
            
            WOTWEBRequestDefaultLanguage =  WOTApiDefaults.languageRU;
        } else {
            
            WOTWEBRequestDefaultLanguage = language;
        }
    }
    return WOTWEBRequestDefaultLanguage;
}

@end
