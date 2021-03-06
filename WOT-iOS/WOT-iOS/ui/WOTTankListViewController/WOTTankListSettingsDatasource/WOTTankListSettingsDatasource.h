//
//  WOTTankListSettingsDatasource.h
//  WOT-iOS
//
//  Created on 6/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol WOTTankListSettingsDatasourceListener

@required

- (void)willChangeContent;
- (void)didChangeContent;
- (void)didChangeObject:(id _Nullable )anObject atIndexPath:(NSIndexPath *_Nullable)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *_Nullable)newIndexPath;

@end

typedef void(^WOTTankListSettingsDatasourceCreateCallback)(NSManagedObjectContext * _Nullable context, id _Nullable createdObject);

typedef void(^WOTTankListSettingsDatasourceCallback)(void);

@interface WOTTankListSettingsDatasource : NSObject

@property (nonatomic, readonly) NSString * _Nullable groupBy;
@property (nonatomic, readonly) NSArray <NSSortDescriptor *>*  _Nonnull sortBy;
@property (nonatomic, readonly) NSCompoundPredicate * _Nullable filterBy;
@property (nonatomic, readonly) NSManagedObjectContext * _Nullable context;
@property (nonatomic, readonly) NSFetchedResultsController * _Nullable fetchedResultController;

+ (id _Nonnull )context:(NSManagedObjectContext *_Nonnull)context createSortSettingForKey:(NSString *_Nonnull)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback _Nullable )callback;
+ (id _Nonnull )context:(NSManagedObjectContext *_Nonnull)context createGroupBySettingForKey:(NSString *_Nullable)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback _Nullable )callback;
+ (id _Nonnull )context:(NSManagedObjectContext *_Nonnull)context createFilterBySettingForKey:(NSString *_Nullable)key value:(NSString *_Nullable)value callback:(WOTTankListSettingsDatasourceCreateCallback _Nullable )callback;

- (void)registerListener:(id <WOTTankListSettingsDatasourceListener> _Nullable )listener;
- (void)unregisterListener:(id <WOTTankListSettingsDatasourceListener> _Nullable)listener;
- (void)setting:(id _Nonnull )setting setOrderIndex:(NSInteger)orderIndex;
- (void)setting:(id _Nullable )setting setType:(NSString *_Nullable)type;
- (void)setting:(id _Nullable )setting setAscending:(BOOL)ascending;
- (void)setting:(id _Nonnull )setting setKey:(NSString *_Nullable)key;
- (void)setting:(id _Nullable )setting setValues:(NSString *_Nonnull)values;
- (id _Nullable )keyForSetting:(id _Nullable )setting;

@end
