//
//  WOTPivotRowNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotRowNode.h"
#import "WOTNode+Enumeration.h"

@implementation WOTPivotRowNode

- (NSInteger)y {
    
    NSInteger result = 0;
    result += [self childrenWidthForSiblingNode:self orValue:1];
    result += self.dimensionDelegate.rootNodeWidth;
    return result;
}

- (NSInteger)x {
    
    return [self visibleParentsCount];
}

- (NSInteger)width {
    
    return 1;
}

- (NSInteger)height {
    
    return self.endpoints.count;

}

- (PivotStickyType)stickyType {
    
    return PivotStickyTypeHorizontal;
}

@end
