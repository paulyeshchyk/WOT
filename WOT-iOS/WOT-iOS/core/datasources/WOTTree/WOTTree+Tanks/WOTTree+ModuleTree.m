//
//  WOTTree+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTree+ModuleTree.h"
#import "WOTNode+ModuleTree.h"
#import "Tanks.h"
#import "ModulesTree+PlainList.h"

@implementation WOTTree (ModuleTree)

- (void)setTankId:(NSNumber *)tankId {

    [self removeAllNodes];

    [self setNodeComparator:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tank_id == %@",tankId];
    Tanks *tanks = [Tanks singleObjectWithPredicate:predicate inManagedObjectContext:[[WOTCoreDataProvider sharedInstance] mainManagedObjectContext] includingSubentities:YES];
    WOTNode *rootNode = [[WOTNode alloc] initWithName:tanks.name_i18n imageURL:[NSURL URLWithString:tanks.image]];

    NSMutableDictionary *plainList = [[NSMutableDictionary alloc] init];
    [tanks.modulesTree enumerateObjectsUsingBlock:^(ModulesTree *module, BOOL *stop) {

        WOTNode *node = [[WOTNode alloc] initWithModuleTree:module];

        plainList[module.module_id] = node;
        [[module plainListForVehicleId:tankId] enumerateObjectsUsingBlock:^(ModulesTree *childModule, BOOL *stop) {

            WOTNode *childNode = [[WOTNode alloc] initWithModuleTree:childModule];
            plainList[childModule.module_id] = childNode;
        }];
    }];

    [[plainList allValues] enumerateObjectsUsingBlock:^(WOTNode *node, NSUInteger idx, BOOL *stop) {
        
        id parentid = node.moduleTree.prevModules.module_id;
        if (parentid) {
            
            WOTNode *parentNode = plainList[parentid];
            if (parentNode) {
                
                [parentNode addChild:node];
            } else {
                
                [rootNode addChild:node];
            }
        } else {
        
            [rootNode addChild:node];
        }
    }];
    
    
    [self addNode:rootNode];
}

- (void)setOfNodes:(NSMutableSet *)setOfNodes addChildNodeForModuleTree:(ModulesTree *)moduleTree{

    [setOfNodes addObject:moduleTree];

    [moduleTree.nextModules enumerateObjectsUsingBlock:^(ModulesTree *nextModule, BOOL *stop) {
       
        [self setOfNodes:setOfNodes addChildNodeForModuleTree:nextModule];
    }];
    
}


@end
