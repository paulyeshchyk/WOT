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

- (PivotStickyType)stickyType {
    return PivotStickyTypeVertical;
}

@end

@implementation WOTPivotColNode(Dimension)

- (NSInteger)y {
    return [WOTNodeEnumerator.sharedInstance visibleParentsCountWithNode:self];
}

- (NSInteger)x {
    NSInteger result  = 0;

    result += [self.dimensionDelegate childrenMaxWidth:self orValue:0];
    result += self.dimensionDelegate.rootNodeWidth;
    return result;
}

- (NSInteger)width {
    NSArray *endPoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode: self];
    if ([endPoints count] == 0) {

        return 1;
    }

    __block NSInteger result = 0;
    [endPoints enumerateObjectsUsingBlock:^(WOTPivotNode *node, NSUInteger idx, BOOL *stop) {
        result += [self.dimensionDelegate maxWidth:node orValue:0];
    }];
    return result;
}

- (NSInteger)height {
    return 1;
}

@end
