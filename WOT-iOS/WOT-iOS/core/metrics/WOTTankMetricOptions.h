//
//  WOTTankMetricOptions.h
//  WOT-iOS
//
//  Created by Paul on 7/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOT_iOS_WOTTankMetricOptions_h
#define WOT_iOS_WOTTankMetricOptions_h

typedef NS_OPTIONS(NSUInteger, WOTTankMetricOptions) {
    WOTTankMetricOptionNone      = 0,
    WOTTankDetailPropertySelectionMobility  = 1 << 0,
    WOTTankMetricOptionArmor     = 1 << 1,
    WOTTankDetailPropertySelectionObserve   = 1 << 2,
    WOTTankDetailPropertySelectionFire      = 1 << 3
};

typedef NS_ENUM(NSUInteger, WOTTankDetailViewMode) {
    WOTTankDetailViewModeUnknown = 0,
    WOTTankDetailViewModeRadar = 1,
    WOTTankDetailViewModeGrid = 2
};

#endif
