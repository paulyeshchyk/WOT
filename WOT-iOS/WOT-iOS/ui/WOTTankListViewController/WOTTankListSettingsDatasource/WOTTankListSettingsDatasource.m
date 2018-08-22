//
//  WOTTankListSettingsDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingsDatasource.h"
#import "ListSetting.h"

@interface WOTTankListSettingsDatasource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSPointerArray *listeners;

@end

@implementation WOTTankListSettingsDatasource

+ (WOTTankListSettingsDatasource *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        [NSThread executeOnMainThread:^{
            
            instance = [[self alloc] init];
        }];
        
    });
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self){

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([ListSetting class]) inManagedObjectContext:self.context];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TYPE ascending:YES],[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_ORDERBY ascending:YES]]];
        
        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:WOT_KEY_TYPE cacheName:nil];
        self.fetchedResultController.delegate = self;

        NSError *error = nil;
        [self.fetchedResultController performFetch:&error];
        
    }
    return self;
}

- (NSManagedObjectContext *)context {
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    return [dataProvider mainManagedObjectContext];
}

- (NSCompoundPredicate *)filterBy {

    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];

    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_FILTER];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];

    for (ListSetting *setting in objects) {
        
        id value = [self filteredValue:setting.values forKey:setting.key];
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",setting.key,value]];
    }

    if ([predicates count] == 0) {
        
        return nil;
    } else {
    
#warning think about or / and predicates
        return [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    }
}

- (NSString *)groupBy {
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_GROUP];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" %K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_SORT];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];

    for (ListSetting *setting in objects) {
        
        [result addObject:[NSSortDescriptor sortDescriptorWithKey:setting.key ascending:[setting.ascending boolValue]]];
    }

    return [result copy];
}

- (id)keyForSetting:(id)setting {

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
+ (id)context:(NSManagedObjectContext *)context createSortSettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback)callback{

    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_KEY,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_SORT];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate]];

    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:compoundPredicate inManagedObjectContext:context];
    setting.key = key;
    setting.ascending = @(ascending);
    setting.type = WOT_KEY_SETTING_TYPE_SORT;
    setting.orderBy = @(orderBy);

    if (callback) {
        
        callback(context,setting);
    }
    return setting;
}

+ (id)context:(NSManagedObjectContext *)context createGroupBySettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback)callback{
    
    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_KEY,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_GROUP];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate]];

    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:compoundPredicate inManagedObjectContext:context];
    setting.key = key;
    setting.ascending = @(ascending);
    setting.type = WOT_KEY_SETTING_TYPE_GROUP;
    setting.orderBy = @(orderBy);

    
    if (callback) {
        
        callback(context,setting);
    }
    return setting;
}

+ (id)context:(NSManagedObjectContext *)context createFilterBySettingForKey:(NSString *)key value:(NSString *)value callback:(WOTTankListSettingsDatasourceCreateCallback)callback{
    
    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_KEY,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_FILTER];
    NSPredicate *valuesPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_VALUES,value];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate,valuesPredicate]];

    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:compoundPredicate inManagedObjectContext:context];
    setting.key = key;
    setting.ascending = @(NO);
    setting.type = WOT_KEY_SETTING_TYPE_FILTER;
    setting.orderBy = @(0);
    setting.values = value;

    
    if (callback) {
        
        callback(context,setting);
    }

    return setting;
}

- (id)filteredValue:(id)value forKey:(NSString *)key {
    
    id result = nil;
    if ([key isEqualToString:WOT_KEY_LEVEL]) {
        
        result = @([value integerValue]);
    } else if ([key isEqualToString:WOT_KEY_IS_PREMIUM]){
        
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
