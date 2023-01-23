//
//  WOTTableViewDatasourceProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WOTTankListSettingType) {
    WOTTankListSettingTypeUnknown = 0,
    WOTTankListSettingTypeNameSelector,
    WOTTankListSettingTypeGroupSelector,
    WOTTankListSettingTypeValueChanger
};

typedef void(^WOTTankListSettingUpateCallback)(id setting);
typedef void(^WOTTankListSettingMoveCompletionCallback)(void);


@protocol WOTTableViewDatasourceProtocol <NSObject>

@required

@property (nonatomic, readonly) NSArray *availableSections;

- (NSString *)sectionNameAtIndex:(NSInteger)index;
- (NSInteger)objectsCountForSection:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath completionBlock:(WOTTankListSettingMoveCompletionCallback)completionBlock;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

- (WOTTankListSettingType)settingTypeForSectionAtIndex:(NSInteger)section;
- (void)updateSetting:(id)setting byType:(id)type byValue:(id)value filterValue:(id)filterValue ascending:(BOOL)ascending callback:(WOTTankListSettingUpateCallback)callback;
- (id)keyForSetting:(id)setting;

- (void)save;
- (void)rollback;

@end
