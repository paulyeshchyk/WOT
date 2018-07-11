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
@end

typedef void(^WOTNodeRemoveCompletionBlock)(WOTNode * node);
