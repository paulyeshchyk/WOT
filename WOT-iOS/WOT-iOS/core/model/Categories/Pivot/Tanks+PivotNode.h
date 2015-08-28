//
//  Tanks+PivotNode.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks.h"
#import "WOTPivotNode.h"

@interface Tanks (PivotNode)

- (WOTPivotNode *)pivotDataNodeForPredicate:(NSPredicate *)predicate;

@end
