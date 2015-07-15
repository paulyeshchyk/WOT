//
//  WOTNode.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTNode : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, readonly)NSArray *children;

- (id)initWithName:(NSString *)name;
- (void)addChild:(WOTNode *)child;
- (void)removeChild:(WOTNode *)child;

@end
