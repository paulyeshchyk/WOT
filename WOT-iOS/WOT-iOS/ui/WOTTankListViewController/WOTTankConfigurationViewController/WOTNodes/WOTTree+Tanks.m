//
//  WOTTree+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree+Tanks.h"
#import "WOTNode+Tanks.h"
#import "Tanks.h"
#import "ModulesTree.h"

@implementation WOTTree (Tanks)

- (void)setTankId:(NSNumber *)tankId {

    [self removeAllNodes];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tank_id == %@",tankId];
    Tanks *tanks = [Tanks singleObjectWithPredicate:predicate inManagedObjectContext:[[WOTCoreDataProvider sharedInstance] mainManagedObjectContext] includingSubentities:YES];
    WOTNode *root = [[WOTNode alloc] initWithName:tanks.name];
    [tanks.modulesTree enumerateObjectsUsingBlock:^(ModulesTree *module, BOOL *stop) {

        [self addNodeForModuleTree:module parentNode:root];
    }];
    
//    WOTNode *root = [self testRoot];
    [self addNode:root];
    [self reindex];
}

- (void)addNodeForModuleTree:(ModulesTree *)module parentNode:(WOTNode *)parentNode{

    WOTNode *node = [[WOTNode alloc] initWithModule:module];
    if (parentNode == nil) {
        
        [self addNode:node];
    } else {
        
        [parentNode addChild:node];
    }
 
    [module.nextModules enumerateObjectsUsingBlock:^(ModulesTree *nextModule, BOOL *stop) {
       
        [self addNodeForModuleTree:nextModule parentNode:node];
    }];
    
}


#pragma mark - private

- (WOTNode *)testRoot {

    WOTNode *node0 = [[WOTNode alloc] initWithName:@"0 (level 0)"];
    WOTNode *node00 = [[WOTNode alloc] initWithName:@"0.0 (level 1)"];
    WOTNode *node01 = [[WOTNode alloc] initWithName:@"0.1 (level 1)"];
    WOTNode *node02 = [[WOTNode alloc] initWithName:@"0.2 (level 1)"];
    [node0 addChild:node00];
    [node0 addChild:node01];
    [node0 addChild:node02];

    WOTNode *node010 = [[WOTNode alloc] initWithName:@"0.1.0 (level 2)"];
    WOTNode *node011 = [[WOTNode alloc] initWithName:@"0.1.1 (level 2)"];
    WOTNode *node012 = [[WOTNode alloc] initWithName:@"0.1.2 (level 2)"];
    WOTNode *node013 = [[WOTNode alloc] initWithName:@"0.1.3 (level 2)"];
    [node01 addChild:node010];
    [node01 addChild:node011];
    [node01 addChild:node012];
    [node01 addChild:node013];

    WOTNode *node0110 = [[WOTNode alloc] initWithName:@"0.1.1.0 (level 3)"];
    WOTNode *node0111 = [[WOTNode alloc] initWithName:@"0.1.1.1 (level 3)"];
    [node011 addChild:node0110];
    [node011 addChild:node0111];

    WOTNode *node01110 = [[WOTNode alloc] initWithName:@"0.1.1.1.0 (level 4)"];
    WOTNode *node01111 = [[WOTNode alloc] initWithName:@"0.1.1.1.1 (level 4)"];
    [node0111 addChild:node01110];
    [node0111 addChild:node01111];

    WOTNode *node020 = [[WOTNode alloc] initWithName:@"0.2.0 (level 2)"];
    WOTNode *node021 = [[WOTNode alloc] initWithName:@"0.2.1 (level 2)"];

    [node02 addChild:node020];
    [node02 addChild:node021];

    WOTNode *node0210 = [[WOTNode alloc] initWithName:@"0.2.1.0 (level 3)"];
    [node020 addChild:node0210];

    return node0;
}
@end
