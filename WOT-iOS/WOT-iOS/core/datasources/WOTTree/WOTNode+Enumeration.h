//
//  WOTNode+Enumeration.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode (Enumeration)

@property (nonatomic, readonly) NSArray *endpoints __deprecated_msg("use WOTEnumerator instead");

@end
