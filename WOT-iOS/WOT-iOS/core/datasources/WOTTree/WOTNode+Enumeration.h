//
//  WOTNode+Enumeration.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode (Enumeration)

@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSArray *endpoints;

+ (WOTNode *)endpointForArray:(NSArray *)childArray atIndexPath:(NSIndexPath *)indexPath;
+ (NSArray *)endpointsForArray:(NSArray *)childArray;
+ (NSArray *)allItemsForArray:(NSArray *)childArray;

@end
