//
//  WOTTankListSettingsDatasource.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTankListSettingsDatasource : NSObject

@property (nonatomic, readonly)NSString *groupBy;
@property (nonatomic, readonly)NSArray *sortBy;
@property (nonatomic, readonly)NSCompoundPredicate *filterBy;
@property (nonatomic, readonly)NSArray *availableSections;


- (NSArray *)objectsForSection:(NSInteger)section;

+ (WOTTankListSettingsDatasource *)sharedInstance;

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void)save;
- (void)rollback;

@end
