//
//  WOTPivot.h
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 8/15/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PivotMetadataType) {
    PivotMetadataTypeFilter = 0,
    PivotMetadataTypeColumn,
    PivotMetadataTypeRow,
    PivotMetadataTypeData
};

typedef NS_ENUM(NSInteger, PivotStickyType) {

    PivotStickyTypeFloat = 0,
    PivotStickyTypeHorizontal = 1 << 1,
    PivotStickyTypeVertical = 1 << 2
};

//! Project version number for WOTPivot.
FOUNDATION_EXPORT double WOTPivotVersionNumber;

//! Project version string for WOTPivot.
FOUNDATION_EXPORT const unsigned char WOTPivotVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WOTPivot/PublicHeader.h>


