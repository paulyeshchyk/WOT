//
//  WOTTankListSettingsDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingsDatasource.h"
//#import "ListSetting.h"

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

@property (nonatomic, strong) NSArray *availableFields;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultControllerForTableRepresentation;

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
//        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
//        NSError *error = nil;
//
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([ListSetting class])];
//        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
//        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//        [self.fetchedResultController performFetch:&error];
//        
//        if ([self.fetchedResultController.fetchedObjects count] == 0) {
//            
////            NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
////
////            [self context:context createSortSettingForKey:WOT_KEY_NATION_I18N ascending:NO orderBy:0];
////            [self context:context createSortSettingForKey:WOT_KEY_TYPE ascending:YES orderBy:1];
////            [self context:context createSortSettingForKey:WOT_KEY_LEVEL ascending:YES orderBy:2];
////
////            
//////            [self context:context createGroupBySettingForKey:WOT_KEY_LEVEL];
////            
////            [self context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"2"];
////            [self context:context createFilterBySettingForKey:WOT_KEY_LEVEL value:@"7"];
//
//        }
//        self.fetchedResultController.delegate = self;
        
    }
    return self;
}

- (NSArray *)availableSections {
    
    return @[@"Filter",@"Group",@"Sort"];
}

- (NSArray *)objectsForSection:(NSInteger)section {
    

    NSArray *result = nil;
    
    switch (section) {
        case 0:{
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@" type == %@",WOT_KEY_SETTING_TYPE_FILTER];
            return [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
            break;
        }
        case 1:{

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@" type == %@",WOT_KEY_SETTING_TYPE_GROUP];
            return [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
            break;
        }
        case 2:{
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@" type == %@",WOT_KEY_SETTING_TYPE_SORT];
            return [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
            break;
        }
        default:
            break;
    }
    
    return result;
}


- (void)save {
    
}

- (void)rollback {
    
}

- (NSCompoundPredicate *)filterBy {
    
//    NSError *error = nil;
//    [self.fetchedResultController performFetch:&error];
//    
//    
//    NSMutableArray *predicates = [[NSMutableArray alloc] init];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" type == %@",WOT_KEY_SETTING_TYPE_FILTER];
//    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
//
//    
//    for (ListSetting *setting in objects) {
//        
//        id value = [self filteredValue:setting.value forKey:setting.key];
//        [predicates addObject:[NSPredicate predicateWithFormat:@"%K = %@",setting.key,value]];
//    }
//    
//
//    return [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    return nil;
}

- (NSString *)groupBy {
    
    NSError *error = nil;

    [self.fetchedResultController performFetch:&error];


    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" type == %@",WOT_KEY_SETTING_TYPE_GROUP];
    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
    NSArray * result = [objects valueForKeyPath:@"key"];
    
    return [result componentsJoinedByString:@","];
}

- (NSArray *)sortBy {
    
//    NSError *error = nil;
//    [self.fetchedResultController performFetch:&error];
//    
//    
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" type == %@",WOT_KEY_SETTING_TYPE_SORT];
//    NSArray *objects = [[self.fetchedResultController fetchedObjects] filteredArrayUsingPredicate:predicate];
//
//    for (ListSetting *setting in objects) {
//        [result addObject:[NSSortDescriptor sortDescriptorWithKey:setting.key ascending:[setting.ascending boolValue]]];
//    }
//
//    return [result copy];
    return nil;
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

//#pragma mark - private
//- (ListSetting *)context:(NSManagedObjectContext *)context createSortSettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy{
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@ AND key == %@",WOT_KEY_SETTING_TYPE_SORT,key];
//    
//    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
//    setting.key = key;
//    setting.ascending = @(ascending);
//    setting.type = WOT_KEY_SETTING_TYPE_SORT;
//    setting.order = @(orderBy);
//
//    if ([context hasChanges]){
//        
//        NSError *error = nil;
//        [context save:&error];
//    }
//    return setting;
//}
//
//- (ListSetting *)context:(NSManagedObjectContext *)context createGroupBySettingForKey:(NSString *)key{
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@ AND key == %@",WOT_KEY_SETTING_TYPE_GROUP,key];
//    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
//    setting.key = key;
//    setting.ascending = @(NO);
//    setting.type = WOT_KEY_SETTING_TYPE_GROUP;
//    setting.order = @(0);
//
//    if ([context hasChanges]){
//        
//        NSError *error = nil;
//        [context save:&error];
//    }
//    
//    return setting;
//}
//
//- (ListSetting *)context:(NSManagedObjectContext *)context createFilterBySettingForKey:(NSString *)key value:(NSString *)value{
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@ AND key == %@ AND value == %@",WOT_KEY_SETTING_TYPE_FILTER,key,value];
//    ListSetting *setting = [ListSetting findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
//    setting.key = key;
//    setting.ascending = @(NO);
//    setting.type = WOT_KEY_SETTING_TYPE_FILTER;
//    setting.order = @(0);
//    setting.value = value;
//    
//    if ([context hasChanges]){
//        
//        NSError *error = nil;
//        [context save:&error];
//    }
//    
//    return setting;
//}

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

@end
