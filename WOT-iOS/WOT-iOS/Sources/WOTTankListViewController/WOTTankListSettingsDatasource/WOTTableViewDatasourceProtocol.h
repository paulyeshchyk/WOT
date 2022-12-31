//
//  WOTTableViewDatasourceProtocol.h
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WOTTankListSettingType) {
    WOTTankListSettingTypeUnknown = 0,
    WOTTankListSettingTypeNameSelector,
    WOTTankListSettingTypeGroupSelector,
    WOTTankListSettingTypeValueChanger
};

typedef void(^WOTTankListSettingUpateCallback)(id _Nonnull setting);
typedef void(^WOTTankListSettingMoveCompletionCallback)(void);


@protocol WOTTableViewDatasourceProtocol <NSObject>

@required

@property (nonatomic, readonly) NSArray * _Nonnull availableSections;

- (NSString * _Nonnull)sectionNameAtIndex:(NSInteger)index;
- (NSInteger)objectsCountForSection:(NSInteger)section;
- (id _Nullable)objectAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)moveRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath toIndexPath:(NSIndexPath * _Nonnull)newIndexPath completionBlock:(WOTTankListSettingMoveCompletionCallback _Nonnull)completionBlock;
- (void)removeObjectAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (WOTTankListSettingType)settingTypeForSectionAtIndex:(NSInteger)section;
- (void)updateSetting:(id _Nonnull)setting byType:(id _Nonnull)type byValue:(id _Nonnull)value filterValue:(id _Nullable)filterValue ascending:(BOOL)ascending callback:(WOTTankListSettingUpateCallback _Nonnull)callback;
- (id _Nonnull)keyForSetting:(id _Nonnull)setting;

@end
