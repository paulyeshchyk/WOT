//
//  WOTApplicationDefaults.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTApplicationDefaults.h"

#import <WOTApi/WOTApi.h>
#import <WOTPivot/WOTPivot.h>

#import "WOTTankListSettingsDatasource.h"
#import "NSTimer+BlocksKit.h"
#import "WOTLoginViewController.h"
#import "WOTRequestIds.h"

@implementation WOTApplicationDefaults

+ (void)registerDefaultSettings {
    
    id<WOTAppDelegateProtocol> appDelegate = (id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate];
    id<DataStoreProtocol> coreDataProvider = appDelegate.dataStore;
    id<ManagedObjectContextProtocol> workingContext = [coreDataProvider workingContext];
    [coreDataProvider performWithObjectContext:workingContext block:^(id<ManagedObjectContextProtocol> _Nonnull context) {

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
            
            if ([context hasTheChanges]) {
                
                [context saveContext];
//                NSError *error = nil;
//                [context save:&error];
            }
        }
    }];
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
