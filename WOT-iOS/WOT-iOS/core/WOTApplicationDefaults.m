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
#import "WOTRequestIds.h"

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
    id<WOTRequestCoordinatorProtocol> coordinator = manager.requestManager.requestCoordinator;

    [coordinator requestId:WOTRequestIdLogin registerRequestClass:[WOTWEBRequestLogin class] registerDataAdapterClass:[WOTWebSessionLoginResponseAdapter class]];
    [coordinator requestId:WOTRequestIdLogout registerRequestClass:[WOTWEBRequestLogout class] registerDataAdapterClass:[WOTWebSessionLogoutResponseAdapter class]];
    [coordinator requestId:WOTRequestIdSaveSession registerRequestClass:[WOTSaveSessionRequest class] registerDataAdapterClass:[WOTWebSessionSaveResponseAdapter class]];
    [coordinator requestId:WOTRequestIdClearSession registerRequestClass:[WOTClearSessionRequest class] registerDataAdapterClass:[WOTWebSessionClearResponseAdapter class]];
    [coordinator requestId:WOTRequestIdTankChassis registerRequestClass:[WOTWEBRequestTankChassis class] registerDataAdapterClass:[WOTWebResponseAdapterChassis class]];
    [coordinator requestId:WOTRequestIdTankTurrets registerRequestClass:[WOTWEBRequestTankTurrets class] registerDataAdapterClass:[WOTWebResponseAdapterTurrets class]];
    [coordinator requestId:WOTRequestIdTankGuns registerRequestClass:[WOTWEBRequestTankGuns class] registerDataAdapterClass:[WOTWebResponseAdapterGuns class]];
    [coordinator requestId:WOTRequestIdTankRadios registerRequestClass:[WOTWEBRequestTankRadios class] registerDataAdapterClass:[WOTWebResponseAdapterRadios class]];
    [coordinator requestId:WOTRequestIdTankEngines registerRequestClass:[WOTWEBRequestTankEngines class] registerDataAdapterClass:[WOTWebResponseAdapterEngines class]];
    [coordinator requestId:WOTRequestIdTankVehicles registerRequestClass:[WOTWEBRequestTankVehicles class] registerDataAdapterClass:[VehiclesAdapter class]];
    [coordinator requestId:WOTRequestIdModulesTree registerRequestClass:[WOTWEBRequestModulesTree class] registerDataAdapterClass:[WOTWebResponseAdapterModuleTree class]];
    [coordinator requestId:WOTRequestIdTankProfile registerRequestClass:[WOTWEBRequestTankProfile class] registerDataAdapterClass:[WOTWebResponseAdapterProfile class]];
    
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
            
            WOTWEBRequestDefaultLanguage =  WOTApiDefaults.languageRU;
        } else {
            
            WOTWEBRequestDefaultLanguage = language;
        }
    }
    return WOTWEBRequestDefaultLanguage;
}

@end
