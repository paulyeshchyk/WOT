//
//  WOTNode+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Tanks.h"

#import "ModulesTree+FillProperties.h"
#import <objc/runtime.h>

@implementation WOTNode (Tanks)

+ (NSURL *)imageURLForModuleType:(WOTModuleType)type {

    NSString *name = nil;
    if ((type & WOTModuleTypeChassis) == WOTModuleTypeChassis) {
        
        name = @"WOTModuleTypeChassis";
    } else if ((type & WOTModuleTypeEngine) == WOTModuleTypeEngine) {
        
        name = @"WOTModuleTypeEngine";
    } else if ((type & WOTModuleTypeGuns) == WOTModuleTypeGuns) {
        
        name = @"WOTModuleTypeGuns";
    } else if ((type & WOTModuleTypeRadios) == WOTModuleTypeRadios) {
        
        name = @"WOTModuleTypeRadios";
    } else if ((type & WOTModuleTypeTurrets) == WOTModuleTypeTurrets) {
        
        name = @"WOTModuleTypeTurrets";
    }
    NSURL *result = [[NSBundle mainBundle] URLForResource:name withExtension:@"png"];
    return result;
}

- (id)initWithModuleTree:(ModulesTree *)module {

    WOTModuleType type = [module moduleType];
    NSURL *imageURL = [WOTNode imageURLForModuleType:type];

    WOTNode *result =  [self initWithName:module.name imageURL:imageURL];
    if (result){
        
        [result setModuleTree:module];
    }
    return result;
}


static const void *WOTModuleTree = &WOTModuleTree;
- (void)setModuleTree:(ModulesTree *)moduleTree {
    
    objc_setAssociatedObject(self, WOTModuleTree, moduleTree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ModulesTree *)moduleTree {

    return objc_getAssociatedObject(self, WOTModuleTree);
}

@end
