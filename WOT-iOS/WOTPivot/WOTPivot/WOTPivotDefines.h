//
//  WOTPivotDefines.h
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOTPivotDefines_h
#define WOTPivotDefines_h

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


#endif /* WOTPivotDefines_h */
