//
//  WOTTankListSettingsDatasource+TableView.m
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingsDatasource+TableView.h"
#import "NSThread+ExecutionOnMain.h"

@implementation WOTTankListSettingsDatasource (TableView)

- (WOTTankListSettingType)settingTypeForSectionAtIndex:(NSInteger)section {
    
    switch (section) {
        case 0: {
            return WOTTankListSettingTypeNameSelector;
            break;
        }
        case 1: {
            return WOTTankListSettingTypeGroupSelector;
            break;
        }
        case 2:{
            return WOTTankListSettingTypeValueChanger;
            break;
        }
        default: {
            return WOTTankListSettingTypeUnknown;
            break;
        }
    }
    
    return WOTTankListSettingTypeNameSelector;
}

- (void)updateSetting:(id)setting  byType:(id)type byValue:(id)value filterValue:(id)filterValue  ascending:(BOOL)ascending callback:(WOTTankListSettingUpateCallback)callback {
    
    id updatedSetting = setting;
    
    if (!updatedSetting) {
        
        if ([type isEqualToString:WOT_KEY_SETTING_TYPE_SORT]) {
            
            NSInteger indexOfType = [self.availableSections indexOfObject:type];
            NSInteger orderBy = [self objectsCountForSection:indexOfType];
            [WOTTankListSettingsDatasource context:self.context createSortSettingForKey:value ascending:ascending orderBy:orderBy callback:callback];
        } else if([type isEqualToString:WOT_KEY_SETTING_TYPE_GROUP]){
            
            NSInteger indexOfType = [self.availableSections indexOfObject:type];
            NSInteger orderBy = [self objectsCountForSection:indexOfType];
            [WOTTankListSettingsDatasource context:self.context createGroupBySettingForKey:value ascending:ascending orderBy:orderBy callback:callback];
        } else if ([type isEqualToString:WOT_KEY_SETTING_TYPE_FILTER]) {
            
            [WOTTankListSettingsDatasource context:self.context createFilterBySettingForKey:value value:filterValue callback:callback];
        } else {
            NSCAssert(NO, @"SettingType is not defined");
        }
    } else {
        
        [self setting:updatedSetting setKey:value];
        [self setting:updatedSetting setValues:filterValue];
        [self setting:updatedSetting setAscending:ascending];
        
        if (callback) {
            
            callback(nil, updatedSetting);
        }
    }
}

- (NSArray *)availableSections {
    
    return @[WOT_KEY_SETTING_TYPE_SORT,WOT_KEY_SETTING_TYPE_GROUP,WOT_KEY_SETTING_TYPE_FILTER];
}

- (id<NSFetchedResultsSectionInfo>)sectionInfoAtIndex:(NSInteger)index {
    
    id sectionName = self.availableSections[index];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",sectionName];
    NSArray *filteredSections = [[self.fetchedResultController sections] filteredArrayUsingPredicate:predicate];
    id <NSFetchedResultsSectionInfo> sectionInfo = [filteredSections lastObject];
    return sectionInfo;
}

- (NSString *)sectionNameAtIndex:(NSInteger)index {
    
    return [self availableSections][index];
}

- (NSInteger)objectsCountForSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:indexPath.section];
    NSArray *objects = [sectionInfo objects];
    if (indexPath.row < [objects count]) {

        return objects[indexPath.row];
    } else {
        
        return nil;
    }
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath completionBlock:(WOTTankListSettingMoveCompletionCallback)completionBlock{
    
    [self.context performBlock:^{
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:indexPath.section];
        NSMutableArray *objectsAtSection = [[sectionInfo objects] mutableCopy];

        id setting =  [objectsAtSection objectAtIndex:indexPath.row];
        [objectsAtSection removeObjectAtIndex:indexPath.row];
        [objectsAtSection insertObject:setting atIndex:newIndexPath.row];
        [objectsAtSection enumerateObjectsUsingBlock:^(id setting, NSUInteger idx, BOOL *stop) {
            
            [self setting:setting setOrderIndex:idx];
        }];

        [self stash:^(NSError * _Nullable error) {
            
        
        [NSThread executeOnMainThread:^{
            
            if (completionBlock){
                
                completionBlock();
            }
        }];
        }];

    }];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.context performBlock:^{
        
        NSManagedObject *obj = [self objectAtIndexPath:indexPath];
        
        [self.context deleteObject:obj];
        [self stash:^(NSError * _Nullable error) {
            
        }];
    }];
}

- (void)rollback {
    
    if ([self.context hasChanges]) {
        
        [self.context rollback];
    }
}


@end
