//
//  WOTPivotColNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotColNode.h"
#import "WOTNode+Enumeration.h"

@implementation WOTPivotColNode

- (NSInteger)y {
    
    return self.visibleParentsCount;
}

- (NSInteger)x {
    
    NSInteger result  = 0;
    result += [WOTPivotNode childrenMaxWidthForSiblingNode:self orValue:0];
    result += self.dimensionDelegate.rootNodeWidth;
    return result;
}

- (NSInteger)width {
    
    __block NSInteger result = 0;
    NSArray *endPoints = self.endpoints;
    if ([endPoints count] == 0) {
        
        result = 1;
    } else {
        
        [endPoints enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
            
            result += [node maxWidthOrValue:0];
        }];
    }

    return result;
}

- (NSInteger)height {
    
    return 1;
}


- (PivotStickyType)stickyType {
    
    return PivotStickyTypeVertical;
}

@end
