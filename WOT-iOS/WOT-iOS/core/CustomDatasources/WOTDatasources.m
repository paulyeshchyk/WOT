//
//  WOTDatasources.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/11/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTDatasources.h"
#import "WOTTankListSettingsDatasource.h"
#import "ListSetting.h"

@implementation WOTDatasources

+ (void)registerDefaultData {
    
    [self registerDefaultSettings];
}

+ (void)registerDefaultSettings {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([ListSetting class])];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_ORDERBY ascending:YES]]];
    NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultController performFetch:&error];

#warning will recreate objects if user has deleted everything
    if ([[fetchedResultController fetchedObjects] count] == 0) {
    
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_NATION_I18N ascending:NO orderBy:0];
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_TYPE ascending:YES orderBy:1];
        [WOTTankListSettingsDatasource context:context createSortSettingForKey:WOT_KEY_LEVEL ascending:YES orderBy:2];
        
        
        [WOTTankListSettingsDatasource context:context createGroupBySettingForKey:WOT_KEY_LEVEL];
        
        [WOTTankListSettingsDatasource context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"2"];
        [WOTTankListSettingsDatasource context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"7"];
    }
    
}

@end
