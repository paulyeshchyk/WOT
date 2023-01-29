//
//  WOTTankListSettingsDatasource.m
//  WOT-iOS
//
//  Created on 6/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingsDatasource.h"
#import <WOTApi/WOTApi-Swift.h>

@interface WOTTankListSettingsDatasource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSPointerArray *listeners;

@end

@implementation WOTTankListSettingsDatasource

+ (id<ContextProtocol> _Nonnull) appContext {
    return (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];
}

- (id)init {
    
    self = [super init];
    if (self){
        id<DataStoreProtocol> dataStore = [WOTTankListSettingsDatasource appContext].dataStore;
        NSError *error = nil;
        [dataStore performWithMode:PerformModeRead error:&error block:^(id<ManagedObjectContextProtocol> _Nonnull context) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ListSetting class]) inManagedObjectContext:(NSManagedObjectContext *)context];
            [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOTApiFields.type ascending:YES],[NSSortDescriptor sortDescriptorWithKey:WOTApiKeyOrderBy.orderBy ascending:YES]]];
            
            self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:WOTApiFields.type cacheName:nil];
            self.fetchedResultController.delegate = self;

            NSError *error = nil;
            [self.fetchedResultController performFetch:&error];
        }];
    }
    return self;
}

- (NSCompoundPredicate *)filterBy {

    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];

    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.type,WOTApiSettingType.key_type_filter];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];

    for (ListSetting *setting in objects) {
        
        id value = [self filteredValue:setting.values forKey:setting.key];
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",setting.key,value]];
    }

    if ([predicates count] == 0) {
        
        return nil;
    } else {
    
#warning think about "or / and" predicates
        return [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    }
}

- (NSString *)groupBy {
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.type, WOTApiSettingType.key_type_group];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
    NSArray * result = [objects valueForKeyPath:@"key"];
    if ([result count] == 0) {
        
        return nil;
    } else {
        
        return [result componentsJoinedByString:@","];
    }
}

- (NSArray<NSSortDescriptor *> *  _Nonnull)sortBy {
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" %K == %@",WOTApiFields.type,WOTApiSettingType.key_type_sort];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];

    for (ListSetting *setting in objects) {
        
        [result addObject:[NSSortDescriptor sortDescriptorWithKey:setting.key ascending:[setting.ascending boolValue]]];
    }

    return [result copy];
}

- (id _Nullable)keyForSetting:(id _Nullable)setting {

    if (![setting isKindOfClass:[ListSetting class]]) {

        return nil;
    }
    return [(ListSetting *)setting key];
}

- (void)setting:(id)setting setOrderIndex:(NSInteger)orderIndex {

    if ([setting isKindOfClass:[ListSetting class]]) {
        
        ListSetting *listSetting = (ListSetting *)setting;
        [listSetting setOrderBy:@(orderIndex)];
    }
}

- (void)setting:(id)setting setType:(NSString *)type {
    
    if ([setting isKindOfClass:[ListSetting class]]) {
        
        ListSetting *listSetting = (ListSetting *)setting;
        [listSetting setType:type];
    }
}

- (void)setting:(id)setting setAscending:(BOOL)ascending {
    
    if ([setting isKindOfClass:[ListSetting class]]) {
        
        ListSetting *listSetting = (ListSetting *)setting;
        [listSetting setAscending:@(ascending)];
    }
}

- (void)setting:(id)setting setValues:(NSString *)values {

    if ([setting isKindOfClass:[ListSetting class]]) {
        
        ListSetting *listSetting = (ListSetting *)setting;
        [listSetting setValues:values];
    }
}

- (void)setting:(id)setting setKey:(NSString *)key {
    
    if ([setting isKindOfClass:[ListSetting class]]) {
        
        ListSetting *listSetting = (ListSetting *)setting;
        [listSetting setKey:key];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [[self.listeners allObjects] enumerateObjectsUsingBlock:^(id<WOTTankListSettingsDatasourceListener> observer, NSUInteger idx, BOOL *stop) {
        
        [observer didChangeContent];
    }];
    [self.listeners compact];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

    [[self.listeners allObjects] enumerateObjectsUsingBlock:^(id<WOTTankListSettingsDatasourceListener> observer, NSUInteger idx, BOOL *stop) {
        
        [observer willChangeContent];
    }];
    [self.listeners compact];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    [[self.listeners allObjects] enumerateObjectsUsingBlock:^(id<WOTTankListSettingsDatasourceListener> observer, NSUInteger idx, BOOL *stop) {
        
        [observer didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }];
    [self.listeners compact];
}

#pragma mark - private
+ (void)createSortSettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback)callback{

    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.key,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.type,WOTApiSettingType.key_type_sort];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate]];

    id<ContextProtocol> _Nonnull appContext = [WOTTankListSettingsDatasource appContext];
    NSError *error = nil;
    [appContext.dataStore performWithMode:PerformModeRead error:&error block:^(id<ManagedObjectContextProtocol> _Nonnull context) {
        ListSetting *setting = (ListSetting *)[context findOrCreateObjectWithAppContext:appContext modelClass:ListSetting.class predicate:compoundPredicate];
        setting.key = key;
        setting.ascending = @(ascending);
        setting.type = WOTApiSettingType.key_type_sort;
        setting.orderBy = @(orderBy);

        [context saveWithAppContext:appContext completion:^(id<ManagedObjectContextProtocol> _Nonnull moContext, NSError * _Nullable error) {
            if (callback) {
                callback(setting);
            }
        }];
    }];
}

+ (void)createGroupBySettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback)callback{

    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.key,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.type,WOTApiSettingType.key_type_group];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate]];

    id<ContextProtocol> _Nonnull appContext = [WOTTankListSettingsDatasource appContext];
    NSError *error = nil;
    [appContext.dataStore performWithMode:PerformModeRead error:&error block:^(id<ManagedObjectContextProtocol> _Nonnull context) {
        ListSetting *setting = (ListSetting *)[context findOrCreateObjectWithAppContext:appContext modelClass:ListSetting.class predicate:compoundPredicate];
        setting.key = key;
        setting.ascending = @(ascending);
        setting.type = WOTApiSettingType.key_type_group;
        setting.orderBy = @(orderBy);

        [context saveWithAppContext:appContext completion:^(id<ManagedObjectContextProtocol> _Nonnull moContext, NSError * _Nullable error) {
            if (callback) {
                callback(setting);
            }
        }];
    }];
}

+ (void)createFilterBySettingForKey:(NSString *)key value:(NSString *)value callback:(WOTTankListSettingsDatasourceCreateCallback)callback{
    
    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.key,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.type,WOTApiSettingType.key_type_filter];
    NSPredicate *valuesPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiFields.values,value];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate,valuesPredicate]];

    id<ContextProtocol> _Nonnull appContext = [WOTTankListSettingsDatasource appContext];
    NSError *error = nil;
    [appContext.dataStore performWithMode:PerformModeRead error:&error block:^(id<ManagedObjectContextProtocol> _Nonnull context) {
        ListSetting *setting = (ListSetting *)[context findOrCreateObjectWithAppContext:appContext modelClass:ListSetting.class predicate:compoundPredicate];
        setting.key = key;
        setting.ascending = @(NO);
        setting.type = WOTApiSettingType.key_type_filter;
        setting.orderBy = @(0);
        setting.values = value;
        [context saveWithAppContext:appContext completion:^(id<ManagedObjectContextProtocol> _Nonnull moContext, NSError * _Nullable error) {
            if (callback) {
                callback(setting);
            }
        }];
    }];
}

- (id)filteredValue:(id)value forKey:(NSString *)key {
    
    id result = nil;
    if ([key isEqualToString:WOTApiFields.tier]) {
        
        result = @([value integerValue]);
    } else if ([key isEqualToString: WOTApiFields.is_premium]){
        
        result = @([value integerValue]);
    } else {
        
        result = value;
    }
    return result;
    
}

- (void)registerListener:(id<WOTTankListSettingsDatasourceListener>)listener {

    if (!listener) {
    
        return;
    }
    if (!self.listeners) {
        
        self.listeners = [[NSPointerArray alloc] init];
    }
    
    [self.listeners addPointer:(__bridge void *)listener];
}

- (void)unregisterListener:(id<WOTTankListSettingsDatasourceListener>)listener {

    if (!listener) {
    
        return;
    }
    
    [self.listeners compact];
    
    NSInteger index = [[self.listeners allObjects] indexOfObject:listener];
    
    if (index != NSNotFound) {
        
        [self.listeners removePointerAtIndex:index];
    }
}

@end
