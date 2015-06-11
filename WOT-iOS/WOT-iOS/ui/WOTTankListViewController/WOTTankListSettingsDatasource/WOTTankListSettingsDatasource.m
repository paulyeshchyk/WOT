//
//  WOTTankListSettingsDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingsDatasource.h"
#import "ListSetting.h"

@interface WOTTankListSettingField : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

- (id)initWithKey:(NSString *)key value:(NSString *)value;

@end

@implementation WOTTankListSettingField

- (id)initWithKey:(NSString *)key value:(NSString *)value{
    
    self = [super init];
    if (self){
        
        self.key = key;
        self.value = value;
    }
    return self;
}

@end

@interface WOTTankListSettingsDatasource () <NSFetchedResultsControllerDelegate>

//@property (nonatomic, strong) NSArray *availableFields;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, readonly)NSManagedObjectContext *context;
@property (nonatomic, strong) NSPointerArray *listeners;


@end

@implementation WOTTankListSettingsDatasource

+ (WOTTankListSettingsDatasource *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        if ([NSThread isMainThread]) {
            instance = [[self alloc] init];
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                instance = [[self alloc] init];
            });
        }
        
    });
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self){

//        self.availableFields = @[[[WOTTankListSettingField alloc] initWithKey:WOT_KEY_NATION_I18N value:WOTString(WOT_STRING_NATION_I18N)],
//                                 [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_IS_PREMIUM value:WOTString(WOT_STRING_IS_PREMIUM)],
//                                 [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_LEVEL value:WOTString(WOT_STRING_LEVEL)],
//                                 [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_NAME_I18N value:WOTString(WOT_STRING_NAME_I18N)],
//                                 [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_SHORT_NAME_I18N value:WOTString(WOT_NAME_SHORT_NAME_I18N)],
//                                 [[WOTTankListSettingField alloc] initWithKey:WOT_KEY_TYPE_I18N value:WOTString(WOT_STRING_TYPE_I18N)]
//                                 ];
//        

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

- (NSArray *)availableSections {
    
    return @[WOT_KEY_SETTING_TYPE_SORT,WOT_KEY_SETTING_TYPE_GROUP,WOT_KEY_SETTING_TYPE_FILTER];
}

- (NSInteger)sectionsCount {
    
    return [self.availableSections count];
}

- (NSString *)sectionNameAtIndex:(NSInteger)index {

    return [self availableSections][index];
}

- (id<NSFetchedResultsSectionInfo>)sectionInfoAtIndex:(NSInteger)index {
    
    id sectionName = self.availableSections[index];
    NSArray *filteredSections = [[self.fetchedResultController sections] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@",sectionName]];
    id <NSFetchedResultsSectionInfo> sectionInfo = [filteredSections lastObject];
    return sectionInfo;
}

- (NSInteger)objectsCountForSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:indexPath.section];
    id result = [sectionInfo objects][indexPath.row];
    return result;
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {

    [self.context performBlock:^{

        id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoAtIndex:indexPath.section];
        NSMutableArray *objectsAtSection = [[sectionInfo objects] mutableCopy];
        
        
        ListSetting *setting =  [objectsAtSection objectAtIndex:indexPath.row];
        [objectsAtSection removeObjectAtIndex:indexPath.row];
        [objectsAtSection insertObject:setting atIndex:newIndexPath.row];

        [objectsAtSection enumerateObjectsUsingBlock:^(ListSetting *setting, NSUInteger idx, BOOL *stop) {
           
            setting.orderBy = @(idx);
        }];

    
        if ([self.context hasChanges]) {
            
            NSError *error = nil;
            [self.context save:&error];
        }
    
    }];
}

- (NSManagedObjectContext *)context {
    
    return [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {

    [self.context performBlock:^{

        NSManagedObject *obj = [self objectAtIndexPath:indexPath];

        [self.context deleteObject:obj];
        if ([self.context hasChanges]) {
            
            NSError *error = nil;
            [self.context save:&error];
        }
    }];
}

- (void)save {
    
}

- (void)rollback {
    
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

    return [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
}

- (NSString *)groupBy {
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" %K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_GROUP];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
    NSArray * result = [objects valueForKeyPath:@"key"];
    
    return [result componentsJoinedByString:@","];
}

- (NSArray *)sortBy {
    
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


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
//    [controller performFetch:nil];
    
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
+ (id)context:(NSManagedObjectContext *)context createSortSettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy{

    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_KEY,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_SORT];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate]];

    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:compoundPredicate inManagedObjectContext:context];
    setting.key = key;
    setting.ascending = @(ascending);
    setting.type = WOT_KEY_SETTING_TYPE_SORT;
    setting.orderBy = @(orderBy);

    if ([context hasChanges]){
        
        NSError *error = nil;
        [context save:&error];
    }
    return setting;
}

+ (id)context:(NSManagedObjectContext *)context createGroupBySettingForKey:(NSString *)key{
    
    NSPredicate *keyPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_KEY,key];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TYPE,WOT_KEY_SETTING_TYPE_GROUP];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[keyPredicate,typePredicate]];

    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:compoundPredicate inManagedObjectContext:context];
    setting.key = key;
    setting.ascending = @(NO);
    setting.type = WOT_KEY_SETTING_TYPE_GROUP;
    setting.orderBy = @(0);

    if ([context hasChanges]){
        
        NSError *error = nil;
        [context save:&error];
    }
    
    return setting;
}

+ (id)context:(NSManagedObjectContext *)context createFilterBySettingForKey:(NSString *)key value:(NSString *)value{
    
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
    
    if ([context hasChanges]){
        
        NSError *error = nil;
        [context save:&error];
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
