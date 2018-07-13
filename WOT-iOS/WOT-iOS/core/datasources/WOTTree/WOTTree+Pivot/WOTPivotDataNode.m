//
//  WOTPivotDataNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotDataNode.h"

@implementation WOTPivotDataNode


@end

@implementation WOTPivotDataNode(Dimension)

- (NSInteger)y {

    return self.stepParentRow.relativeRect.origin.y;
}

- (NSInteger)x {

    NSInteger result = 0;
    result += self.stepParentColumn.relativeRect.origin.x;
    result += [self indexInsideStepParentColumn];
    return result;
}

- (NSInteger)width {

    return 1;
}

- (NSInteger)height {

    return 1;
}

@end
