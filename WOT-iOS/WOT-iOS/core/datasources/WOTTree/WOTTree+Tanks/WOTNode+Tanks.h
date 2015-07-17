//
//  WOTNode+Tanks.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"
#import "ModulesTree+FillProperties.h"

@interface WOTNode (Tanks)

@property (nonatomic, strong)ModulesTree *moduleTree;
@property (nonatomic, readonly)WOTModuleType moduleType;
@property (nonatomic, readonly)NSString *moduleTypeString;

- (id)initWithModuleTree:(ModulesTree *)module;
- (void)setModuleTree:(ModulesTree *)moduleTree;
- (ModulesTree *)moduleTree;

@end
