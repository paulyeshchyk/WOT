//
//  WOTPivotFilterNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotFilterNode.h"

@implementation WOTPivotFilterNode

- (NSInteger)y {
    
    return 0;
}

- (NSInteger)x {
    
    return 0;
}

- (NSInteger)width {
    
    return self.dimensionDelegate.rootNodeWidth;
}

- (NSInteger)height {
    
    return self.dimensionDelegate.rootNodeHeight;
}

- (PivotStickyType)stickyType {
    
    return PivotStickyTypeHorizontal | PivotStickyTypeVertical;
}

@end
