//
//  WOTTankListSettingsDatasource+TableView.m
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingsDatasource+TableView.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi.h>

@implementation WOTTankListSettingsDatasource (TableView)

- (WOTTankListSettingType)settingTypeForSectionAtIndex:(NSInteger)section {
    
    switch (section) {
        case 0: {
            return WOTTankListSettingTypeNameSelector;
        }
        case 1: {
            return WOTTankListSettingTypeGroupSelector;
        }
        case 2:{
            return WOTTankListSettingTypeValueChanger;
        }
        default: {
            return WOTTankListSettingTypeUnknown;
        }
    }
    
    return WOTTankListSettingTypeNameSelector;
}

- (void)updateSetting:(id)setting  byType:(id)type byValue:(id)value filterValue:(id)filterValue  ascending:(BOOL)ascending callback:(WOTTankListSettingUpateCallback)callback {
    
    id updatedSetting = setting;
    
    if (!updatedSetting) {
        
        if ([type isEqualToString:WOTApiSettingType.key_type_sort]) {
            
            NSInteger indexOfType = [self.availableSections indexOfObject:type];
            NSInteger orderBy = [self objectsCountForSection:indexOfType];
            [WOTTankListSettingsDatasource createSortSettingForKey:value ascending:ascending orderBy:orderBy callback:callback];
        } else if([type isEqualToString:WOTApiSettingType.key_type_group]){
            
            NSInteger indexOfType = [self.availableSections indexOfObject:type];
            NSInteger orderBy = [self objectsCountForSection:indexOfType];
            [WOTTankListSettingsDatasource createGroupBySettingForKey:value ascending:ascending orderBy:orderBy callback:callback];
        } else if ([type isEqualToString:WOTApiSettingType.key_type_filter]) {
            
            [WOTTankListSettingsDatasource createFilterBySettingForKey:value value:filterValue callback:callback];
        } else {
            NSCAssert(NO, @"SettingType is not defined");
        }
    } else {
        
        [self setting:updatedSetting setKey:value];
        [self setting:updatedSetting setValues:filterValue];
        [self setting:updatedSetting setAscending:ascending];
        
        if (callback) {
            
            callback(updatedSetting);
        }
    }
}

- (NSArray *)availableSections {
    
    return @[WOTApiSettingType.key_type_sort,WOTApiSettingType.key_type_group,WOTApiSettingType.key_type_filter];
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

- (id _Nullable)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:indexPath.section];
    NSArray *objects = [sectionInfo objects];
    if (indexPath.row < [objects count]) {
        return objects[indexPath.row];
    } else {
        return nil;
    }
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath completionBlock:(WOTTankListSettingMoveCompletionCallback)completionBlock{
    id<ContextProtocol> appDelegate = (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];
    [appDelegate.dataStore performWithBlock:^(id<ManagedObjectContextProtocol> _Nonnull context) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:indexPath.section];
        NSMutableArray *objectsAtSection = [[sectionInfo objects] mutableCopy];

        id setting =  [objectsAtSection objectAtIndex:indexPath.row];
        [objectsAtSection removeObjectAtIndex:indexPath.row];
        [objectsAtSection insertObject:setting atIndex:newIndexPath.row];
        [objectsAtSection enumerateObjectsUsingBlock:^(id setting, NSUInteger idx, BOOL *stop) {
            
            [self setting:setting setOrderIndex:idx];
        }];

        [appDelegate.dataStore stashWithObjectContext:context completion:^(NSError * _Nullable error) {
            [NSThread executeOnMainThread:^{
                
                if (completionBlock){
                    
                    completionBlock();
                }
            }];
        }];
    }];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    id<ContextProtocol> appDelegate = (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];
    [appDelegate.dataStore performWithBlock:^(id<ManagedObjectContextProtocol> _Nonnull context) {

        NSManagedObject *obj = [self objectAtIndexPath:indexPath];
        
        [(NSManagedObjectContext *)context deleteObject:obj];
        [appDelegate.dataStore stashWithObjectContext:context completion:^(NSError * _Nullable error) {
            //
        }];
    }];
}

@end
