//
//  WOTNode+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+ModuleTree.h"
#import "ModulesTree+UI.h"
#import "ModulesTree+FillProperties.h"
#import <objc/runtime.h>

@implementation WOTNode (ModuleTree)


- (id)initWithModuleTree:(ModulesTree *)module {

    NSURL *imageURL = [module localImageURL];
    WOTNode *result = [self initWithName:module.name imageURL:imageURL];
    if (result){
        
        [result setModuleTree:module];
    }
    return result;
}

- (WOTModuleType) moduleType {

    return [self moduleTree].moduleType;
}

static const void *WOTModuleTree = &WOTModuleTree;
- (void)setModuleTree:(ModulesTree *)moduleTree {
    
    objc_setAssociatedObject(self, WOTModuleTree, moduleTree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ModulesTree *)moduleTree {

    return objc_getAssociatedObject(self, WOTModuleTree);
}

@end
