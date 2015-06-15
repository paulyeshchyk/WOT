//
//  WOTTankListSettingsDatasource.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTTankListSettingsDatasourceListener

@required

- (void)willChangeContent;
- (void)didChangeContent;
- (void)didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;

@end

typedef void(^WOTTankListSettingsDatasourceCreateCallback)(NSManagedObjectContext *context, id createdObject);

typedef void(^WOTTankListSettingsDatasourceCallback)(void);

@interface WOTTankListSettingsDatasource : NSObject

@property (nonatomic, readonly) NSString *groupBy;
@property (nonatomic, readonly) NSArray *sortBy;
@property (nonatomic, readonly) NSCompoundPredicate *filterBy;
@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultController;

+ (WOTTankListSettingsDatasource *)sharedInstance;

+ (id)context:(NSManagedObjectContext *)context createSortSettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback)callback;
+ (id)context:(NSManagedObjectContext *)context createGroupBySettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy callback:(WOTTankListSettingsDatasourceCreateCallback)callback;
+ (id)context:(NSManagedObjectContext *)context createFilterBySettingForKey:(NSString *)key value:(NSString *)value callback:(WOTTankListSettingsDatasourceCreateCallback)callback;

- (void)registerListener:(id<WOTTankListSettingsDatasourceListener>)listener;
- (void)unregisterListener:(id<WOTTankListSettingsDatasourceListener>)listener;
- (void)setting:(id)setting setOrderIndex:(NSInteger)orderIndex;
- (void)setting:(id)setting setType:(NSString *)type;
- (void)setting:(id)setting setAscending:(BOOL)ascending;
- (void)setting:(id)setting setKey:(NSString *)key;
- (void)setting:(id)setting setValues:(NSString *)values;
- (id)keyForSetting:(id)setting;


@end
