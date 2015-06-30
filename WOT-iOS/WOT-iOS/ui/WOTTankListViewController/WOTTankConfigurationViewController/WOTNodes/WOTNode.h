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
@property (nonatomic, readonly)NSArray *allChildren;
@property (nonatomic, readonly)NSInteger depth;
@property (nonatomic, readonly)NSInteger width;
@property (nonatomic, readonly)NSInteger level;
@property (nonatomic, readonly)NSIndexPath *siblingIndexPath;

- (id)initWithName:(NSString *)name parent:(WOTNode *)parent;

//- (void)addChildren:(NSSet *)children;
- (void)addChild:(WOTNode *)child;
- (void)removeChild:(WOTNode *)child;
- (NSArray *)nodesAtLevel:(NSInteger)level;
- (WOTNode *)nodeAtSiblingIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)indexOfChild:(WOTNode *)node;

@end
