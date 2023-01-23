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
@property (nonatomic, weak)WOTNode *parent;
@property (nonatomic, readonly)NSURL *imageURL;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name imageURL:(NSURL *)imageURL;
- (void)addChild:(WOTNode *)child;
- (void)removeChild:(WOTNode *)child;

@end
