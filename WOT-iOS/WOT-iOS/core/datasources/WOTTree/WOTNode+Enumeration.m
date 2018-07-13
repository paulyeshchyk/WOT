//
//  WOTNode+Enumeration.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Enumeration.h"

@implementation WOTNode (Enumeration)

- (NSArray *)endpoints {
    return [WOTNodeEnumerator.sharedInstance endpointsWithNode: self];
}

@end
