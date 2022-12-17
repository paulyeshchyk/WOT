//
//  WOTPivotDefines.h
//  WOTPivot
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//

#ifndef WOTPivotDefines_h
#define WOTPivotDefines_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PivotStickyType) {

    PivotStickyTypeFloat = 0,
    PivotStickyTypeHorizontal = 1 << 1,
    PivotStickyTypeVertical = 1 << 2
};

typedef NS_ENUM(NSInteger, PivotMetadataType) {
    PivotMetadataTypeFilter = 0,
    PivotMetadataTypeColumn,
    PivotMetadataTypeRow,
    PivotMetadataTypeData
};


#endif /* WOTPivotDefines_h */
