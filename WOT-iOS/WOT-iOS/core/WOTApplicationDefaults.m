//
//  WOTApplicationDefaults.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTApplicationDefaults.h"

#import "ListSetting.h"
#import "WOTTankListSettingsDatasource.h"

#import "WOTRequestExecutor.h"
#import "WOTWEBRequestLogin.h"
#import "WOTWEBRequestLogout.h"

#import "WOTWebResponseAdapterLogin.h"
#import "WOTWebResponseAdapterTanks.h"
#import "WOTSaveSessionRequest.h"
#import "WOTClearSessionRequest.h"
#import "WOTWebRequestTankChassis.h"
#import "WOTWebRequestTankTurrets.h"
#import "WOTWebRequestTankGuns.h"
#import "WOTWebRequestTankRadios.h"

#import "WOTSessionManager.h"
#import "WOTWEBRequestTanks.h"
#import "WOTWEBRequestTankEngines.h"
#import "WOTWebResponseAdapterEngines.h"
#import "WOTWEBRequestTankVehicles.h"
#import "WOTWebResponseAdapterVehicles.h"
#import "WOTWebResponseAdapterChassis.h"
#import "WOTWebResponseAdapterTurrets.h"
#import "WOTWebResponseAdapterGuns.h"
#import "WOTWebResponseAdapterRadios.h"

@implementation WOTApplicationDefaults


+ (void)registerDefaultSettings {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([ListSetting class])];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_ORDERBY ascending:YES]]];
    NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultController performFetch:&error];
    
#warning will recreate objects if user has deleted everything
    if ([[fetchedResultController fetchedObjects] count] == 0) {
        
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_NATION_I18N ascending:NO orderBy:0 callback:NULL];
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_TYPE ascending:YES orderBy:1 callback:NULL];
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_LEVEL ascending:YES orderBy:2 callback:NULL];
        
        
        [WOTTankListSettingsDatasource context:context createGroupBySettingForKey:WOT_KEY_LEVEL ascending:NO orderBy:0 callback:NULL];
        
        [WOTTankListSettingsDatasource context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"2" callback:NULL];
        [WOTTankListSettingsDatasource context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"7" callback:NULL];
        
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
            [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdClearSession args:nil inQueue:nil];
            [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdLogin args:nil inQueue:nil];
        }
        
    }];
    
    
    /**
     * Save Sassion
     **/
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestClass:[WOTSaveSessionRequest class]];
    [[WOTRequestExecutor sharedInstance] requestId:WOTRequestIdSaveSession registerRequestCallback:^(id data, NSError *error) {
        
        [[WOTSessionManager sharedInstance] invalidateTimer];
        
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
    
}


@end
