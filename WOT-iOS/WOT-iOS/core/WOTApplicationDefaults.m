//
//  WOTApplicationDefaults.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTApplicationDefaults.h"

#import <WOTData/WOTData.h>
#import <WOTPivot/WOTPivot.h>

#import "WOTTankListSettingsDatasource.h"
#import "WOTWebResponseAdapterLogin.h"
#import "NSTimer+BlocksKit.h"

@implementation WOTApplicationDefaults

+ (void)registerDefaultSettings {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];

    NSString *entityName = NSStringFromClass([ListSetting class]);
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_ORDERBY ascending:YES]]];
    NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultController performFetch:&error];
    
#warning will recreate objects if user has deleted everything
    if ([[fetchedResultController fetchedObjects] count] == 0) {
        
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_NATION_I18N ascending:NO orderBy:0 callback:NULL];
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_TYPE ascending:YES orderBy:1 callback:NULL];
        
        
        [WOTTankListSettingsDatasource context:context createGroupBySettingForKey:WOT_KEY_NATION_I18N ascending:YES orderBy:0 callback:NULL];
        
        [WOTTankListSettingsDatasource context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"6" callback:NULL];
        
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
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerRequestClass:[WOTWEBRequestLogin class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogin registerDataAdapterClass:[WOTWebResponseAdapterLogin class]];

    /**
     * Logout
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestClass:[WOTWEBRequestLogout class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdLogout registerRequestCallback:^(id data, NSError *error) {
        
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
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestCallback:^(id data, NSError *error) {
        
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
     * Tanks.Tanks
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTanks registerDataAdapterClass:[WOTWebResponseAdapterTanks class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTanks registerRequestClass:[WOTWEBRequestTanks class]];

    /**
     * Tanks.Chassis
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankChassis registerRequestClass:[WOTWebRequestTankChassis class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankChassis registerDataAdapterClass:[WOTWebResponseAdapterChassis class]];
    
    /**
     * Tanks.Turrets
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankTurrets registerRequestClass:[WOTWebRequestTankTurrets class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankTurrets registerDataAdapterClass:[WOTWebResponseAdapterTurrets class]];
    
    /**
     * Tanks.Guns
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankGuns registerRequestClass:[WOTWebRequestTankGuns class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankGuns registerDataAdapterClass:[WOTWebResponseAdapterGuns class]];
    
    /**
     * Tanks.Radios
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankRadios registerRequestClass:[WOTWebRequestTankRadios class]];
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
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankVehicles registerDataAdapterClass:[WOTWebResponseAdapterVehicles class]];
    
    /**
     * Tanks.Modules
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdModulesTree registerRequestClass:[WOTWEBRequestTankVehicles class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdModulesTree registerDataAdapterClass:[WOTWebResponseAdapterVehicles class]];

    /**
     * Tanks.Profile
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankProfile registerRequestClass:[WOTWEBRequestTankProfile class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdTankProfile registerDataAdapterClass:[WOTWebResponseAdapterProfile class]];
    
}


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
            
            WOTWEBRequestDefaultLanguage =  WOT_USERDEFAULTS_LOGIN_LANGUAGEVALUE_RU;
        } else {
            
            WOTWEBRequestDefaultLanguage = language;
        }
    }
    return WOTWEBRequestDefaultLanguage;
}


+ (NSString *)host {
    
    return [NSString stringWithFormat:@"%@.%@",ApplicationHost,[self language]];
}

@end
