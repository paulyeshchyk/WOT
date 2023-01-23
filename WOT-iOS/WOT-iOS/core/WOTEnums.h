//
//  WOTEnums.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOT_iOS_WOTEnums_h
#define WOT_iOS_WOTEnums_h

typedef NS_ENUM(NSInteger, WOTRequestId) {
    WOTRequestIdLogin = 0,
    WOTRequestIdSaveSession,
    WOTRequestIdLogout,
    WOTRequestIdClearSession,
    WOTRequestIdTanks,
    WOTRequestIdTankEngines,
    WOTRequestIdTankChassis,
    WOTRequestIdTankTurrets,
    WOTRequestIdTankGuns,
    WOTRequestIdTankRadios,
    WOTRequestIdTankVehicles,
    WOTRequestIdTankProfile,
    WOTRequestIdModulesTree
};

typedef NS_ENUM(NSInteger, WOTModuleType){
    WOTModuleTypeUnknown  = 1 << 0,
    WOTModuleTypeChassis  = 1 << 1,
    WOTModuleTypeEngine = 1 << 2,
    WOTModuleTypeRadios = 1 << 3,
    WOTModuleTypeTurrets = 1 << 4,
    WOTModuleTypeGuns = 1 << 5,
    WOTModuleTypeTank = 1 << 6
};

typedef NS_ENUM(NSInteger, PivotStickyType) {
    
    PivotStickyTypeFloat = 0,
    PivotStickyTypeHorizontal = 1 << 1,
    PivotStickyTypeVertical = 1 << 2
};



typedef CGSize(^LayoutRelativeContentSizeBlock)(void);
typedef NSInteger(^LayoutDimensionBlock)(void);
typedef PivotStickyType (^LayoutStickyType)(NSIndexPath *indexPath);
typedef CGRect(^LayoutRelativeRectBlock)(NSIndexPath *indexPath);
typedef NSInteger(^LayoutSiblingChildrenCount)(NSIndexPath *);
typedef NS_ENUM(NSInteger, LayoutOrientation){
    LayoutOrientationHorizontal,
    LayoutOrientationVertical
};



#endif
