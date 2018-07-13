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

- (PivotStickyType)stickyType {
    return PivotStickyTypeHorizontal;
}

@end

@implementation WOTPivotRowNode (Dimension)

- (NSInteger)y {

    NSInteger result = 0;
    result += [WOTNodeEnumerator.sharedInstance childrenWidthWithSiblingNode:self orValue:1];
    result += self.dimensionDelegate.rootNodeHeight;
    return result;
}

- (NSInteger)x {
    return [WOTNodeEnumerator.sharedInstance visibleParentsCountWithNode:self];
}

- (NSInteger)width {

    return 1;
}

- (NSInteger)height {
    NSArray *endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode: self];
    return endpoints.count;

}

@end
