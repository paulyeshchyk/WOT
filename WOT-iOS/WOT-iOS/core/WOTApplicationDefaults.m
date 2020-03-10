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
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdLogin registerRequestClass:[WOTWEBRequestLogin class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdLogin registerRequestCompletion:^(NSData *binary, NSError *error) {

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

    }];

    /**
     * Logout
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdLogout registerRequestClass:[WOTWEBRequestLogout class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdLogout registerRequestCompletion:^(NSData *binary, NSError *error) {
        
        if (error){
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WOT_NOTIFICATION_LOGOUT object:nil userInfo:nil];
            WOTRequest *clearSessionRequest = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdClearSession];
            [clearSessionRequest start:nil];
            
            WOTRequest *loginRequest = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdLogin];
            [loginRequest start:nil];
        }
        
    }];

    /**
     * Save Sassion
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdSaveSession registerRequestClass:[WOTSaveSessionRequest class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdSaveSession registerRequestCompletion:^(NSData *binary, NSError *error) {
        
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
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdClearSession registerRequestClass:[WOTClearSessionRequest class]];

    /**
     * Tanks.Chassis
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankChassis registerRequestClass:[WOTWEBRequestTankChassis class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankChassis registerDataAdapterClass:[WOTWebResponseAdapterChassis class]];
    
    /**
     * Tanks.Turrets
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankTurrets registerRequestClass:[WOTWEBRequestTankTurrets class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankTurrets registerDataAdapterClass:[WOTWebResponseAdapterTurrets class]];
    
    /**
     * Tanks.Guns
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankGuns registerRequestClass:[WOTWEBRequestTankGuns class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankGuns registerDataAdapterClass:[WOTWebResponseAdapterGuns class]];
    
    /**
     * Tanks.Radios
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankRadios registerRequestClass:[WOTWEBRequestTankRadios class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankRadios registerDataAdapterClass:[WOTWebResponseAdapterRadios class]];
    
    /**
     * Tanks.Engines
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankEngines registerRequestClass:[WOTWEBRequestTankEngines class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankEngines registerDataAdapterClass:[WOTWebResponseAdapterEngines class]];

    /**
     * Tanks.Vehicles
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankVehicles registerRequestClass:[WOTWEBRequestTankVehicles class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankVehicles registerDataAdapterClass:[VehiclesAdapter class]];
    
    /**
     * Tanks.Modules
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdModulesTree registerRequestClass:[WOTWEBRequestModulesTree class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdModulesTree registerDataAdapterClass:[WOTWebResponseAdapterModuleTree class]];

    /**
     * Tanks.Profile
     **/
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankProfile registerRequestClass:[WOTWEBRequestTankProfile class]];
    [[WOTRequestReception sharedInstance] requestId:WOTRequestIdTankProfile registerDataAdapterClass:[WOTWebResponseAdapterProfile class]];
    
}

WOTLoginCallback loginCallback = ^(WOTLogin *wotLogin){

    NSDictionary *argsDictionary = [wotLogin asDictionary];
    WOTRequestArguments *args = [[WOTRequestArguments alloc] init:argsDictionary];

    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdSaveSession];
    [request start:args];

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
