//
//  PivotStickyType.h
//  WOTPivot
//
//  Created by Paul on 31.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

#ifndef PivotStickyType_h
#define PivotStickyType_h

typedef NS_ENUM(NSInteger, PivotStickyType) {

    PivotStickyTypeFloat = 0,
    PivotStickyTypeHorizontal = 1 << 1,
    PivotStickyTypeVertical = 1 << 2
};

#endif /* PivotStickyType_h */
