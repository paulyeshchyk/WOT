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

    id<WOTPivotAppManagerProtocol> manager = ((id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate]).appManager;
    id<WOTRequestReceptionProtocol> reception = manager.requestManager.requestReception;

    /**
     * Login
     **/
    [reception requestId:WOTRequestIdLogin registerRequestClass:[WOTWEBRequestLogin class]];
    [reception requestId:WOTRequestIdLogin registerRequestCompletion:^(NSData *binary, NSError *error) {

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
    [reception requestId:WOTRequestIdLogout registerRequestClass:[WOTWEBRequestLogout class]];
    [reception requestId:WOTRequestIdLogout registerRequestCompletion:^(NSData *binary, NSError *error) {
        
        if (error){
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo description] delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil] show];
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WOT_NOTIFICATION_LOGOUT object:nil userInfo:nil];

            id<WOTRequestProtocol> clearSessionRequest = [reception createRequestForRequestId:WOTRequestIdClearSession];
            clearSessionRequest.hostConfiguration = manager.hostConfiguration;
            [clearSessionRequest start: [[WOTRequestArguments alloc] init]];
            
            
            id<WOTRequestProtocol> loginRequest = [reception createRequestForRequestId:WOTRequestIdLogin];
            loginRequest.hostConfiguration = manager.hostConfiguration;
            [loginRequest start: [[WOTRequestArguments alloc] init] ];
        }
        
    }];

    /**
     * Save Sassion
     **/
    [reception requestId:WOTRequestIdSaveSession registerRequestClass:[WOTSaveSessionRequest class]];
    [reception requestId:WOTRequestIdSaveSession registerRequestCompletion:^(NSData *binary, NSError *error) {
        
        [[WOTSessionManager sharedInstance] invalidateTimer:^NSTimer *(NSTimeInterval interval) {
            NSTimer *timer = [NSTimer bk_scheduledTimerWithTimeInterval:interval block:^(NSTimer *timer) {

                [WOTSessionManager logoutWithRequestManager:manager.requestManager hostConfiguration:manager.hostConfiguration];
            } repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            return timer;
        }];
        
    }];

    /**
     * Clear Sassion
     **/
    [reception requestId:WOTRequestIdClearSession registerRequestClass:[WOTClearSessionRequest class]];

    /**
     * Tanks.Chassis
     **/
    [reception requestId:WOTRequestIdTankChassis registerRequestClass:[WOTWEBRequestTankChassis class]];
    [reception requestId:WOTRequestIdTankChassis registerDataAdapterClass:[WOTWebResponseAdapterChassis class]];
    
    /**
     * Tanks.Turrets
     **/
    [reception requestId:WOTRequestIdTankTurrets registerRequestClass:[WOTWEBRequestTankTurrets class]];
    [reception requestId:WOTRequestIdTankTurrets registerDataAdapterClass:[WOTWebResponseAdapterTurrets class]];
    
    /**
     * Tanks.Guns
     **/
    [reception requestId:WOTRequestIdTankGuns registerRequestClass:[WOTWEBRequestTankGuns class]];
    [reception requestId:WOTRequestIdTankGuns registerDataAdapterClass:[WOTWebResponseAdapterGuns class]];
    
    /**
     * Tanks.Radios
     **/
    [reception requestId:WOTRequestIdTankRadios registerRequestClass:[WOTWEBRequestTankRadios class]];
    [reception requestId:WOTRequestIdTankRadios registerDataAdapterClass:[WOTWebResponseAdapterRadios class]];
    
    /**
     * Tanks.Engines
     **/
    [reception requestId:WOTRequestIdTankEngines registerRequestClass:[WOTWEBRequestTankEngines class]];
    [reception requestId:WOTRequestIdTankEngines registerDataAdapterClass:[WOTWebResponseAdapterEngines class]];

    /**
     * Tanks.Vehicles
     **/
    [reception requestId:WOTRequestIdTankVehicles registerRequestClass:[WOTWEBRequestTankVehicles class]];
    [reception requestId:WOTRequestIdTankVehicles registerDataAdapterClass:[VehiclesAdapter class]];
    
    /**
     * Tanks.Modules
     **/
    [reception requestId:WOTRequestIdModulesTree registerRequestClass:[WOTWEBRequestModulesTree class]];
    [reception requestId:WOTRequestIdModulesTree registerDataAdapterClass:[WOTWebResponseAdapterModuleTree class]];

    /**
     * Tanks.Profile
     **/
    [reception requestId:WOTRequestIdTankProfile registerRequestClass:[WOTWEBRequestTankProfile class]];
    [reception requestId:WOTRequestIdTankProfile registerDataAdapterClass:[WOTWebResponseAdapterProfile class]];
    
}

WOTLoginCallback loginCallback = ^(WOTLogin *wotLogin){

    id<WOTPivotAppManagerProtocol> manager = ((id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate]).appManager;
    id<WOTRequestReceptionProtocol> requestReception = manager.requestManager.requestReception;

    NSDictionary *argsDictionary = [wotLogin asDictionary];
    WOTRequestArguments *args = [[WOTRequestArguments alloc] init:argsDictionary];

    id<WOTHostConfigurationOwner> hostOwner = (id<WOTHostConfigurationOwner>) [UIApplication sharedApplication].delegate;
    id<WOTRequestProtocol> request = [requestReception createRequestForRequestId:WOTRequestIdSaveSession];
    request.hostConfiguration = hostOwner.hostConfiguration;
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
