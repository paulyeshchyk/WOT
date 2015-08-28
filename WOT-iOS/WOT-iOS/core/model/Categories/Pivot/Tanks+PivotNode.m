//
//  Tanks+PivotNode.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/28/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks+PivotNode.h"
#import "WOTNode+PivotFactory.h"
#import "WOTPivotDataNode.h"

@implementation Tanks (PivotNode)

- (WOTPivotNode *)pivotDataNodeForPredicate:(NSPredicate *)predicate {
    
    NSURL *imageURL = [NSURL URLWithString:[self image]];
    WOTPivotNode *node = [[WOTPivotDataNode alloc] initWithName:[self short_name_i18n] imageURL:imageURL predicate:predicate];
    
    node.dataColor = [UIColor whiteColor];
    NSDictionary *colors = [WOTNode typeColors];
    
    node.dataColor = colors[self.type];
    
    [node setData1:self];
    return node;
}

@end
