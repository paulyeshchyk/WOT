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

typedef void(^WOTTankListSettingsDatasourceCallback)(void);

@interface WOTTankListSettingsDatasource : NSObject

@property (nonatomic, readonly)NSString *groupBy;
@property (nonatomic, readonly)NSArray *sortBy;
@property (nonatomic, readonly)NSCompoundPredicate *filterBy;
@property (nonatomic, readonly)NSInteger sectionsCount;


+ (id)context:(NSManagedObjectContext *)context createSortSettingForKey:(NSString *)key ascending:(BOOL)ascending orderBy:(NSInteger)orderBy;
+ (id)context:(NSManagedObjectContext *)context createGroupBySettingForKey:(NSString *)key;
+ (id)context:(NSManagedObjectContext *)context createFilterBySettingForKey:(NSString *)key value:(NSString *)value;

- (void)registerListener:(id<WOTTankListSettingsDatasourceListener>)listener;
- (void)unregisterListener:(id<WOTTankListSettingsDatasourceListener>)listener;

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
- (NSString *)sectionNameAtIndex:(NSInteger)index;
- (NSInteger)objectsCountForSection:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
+ (WOTTankListSettingsDatasource *)sharedInstance;

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void)save;
- (void)rollback;

@end
