//
//  WOTNode.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WOTNodeProtocol;

@interface WOTNode : NSObject <WOTNodeProtocol>
@property (nonatomic, readonly) NSArray *endpoints __deprecated_msg("use WOTEnumerator instead");
@end

typedef void(^WOTNodeRemoveCompletionBlock)(WOTNode * node);
