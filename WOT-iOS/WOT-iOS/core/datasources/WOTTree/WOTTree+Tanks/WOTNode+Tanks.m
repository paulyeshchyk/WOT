//
//  WOTNode+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Tanks.h"

#import <objc/runtime.h>

@implementation WOTNode (Tanks)

+ (NSURL *)imageURLForModuleType:(WOTModuleType)type {

    NSString *name = [self moduleTypeStringForModuleType:type];
    return [[NSBundle mainBundle] URLForResource:name withExtension:@"png"];
}

+ (NSString *)moduleTypeStringForModuleType:(WOTModuleType)moduleType {
    
    NSString *name = nil;
    if ((moduleType & WOTModuleTypeChassis) == WOTModuleTypeChassis) {
        
        name = @"WOTModuleTypeChassis";
    } else if ((moduleType & WOTModuleTypeEngine) == WOTModuleTypeEngine) {
        
        name = @"WOTModuleTypeEngine";
    } else if ((moduleType & WOTModuleTypeGuns) == WOTModuleTypeGuns) {
        
        name = @"WOTModuleTypeGuns";
    } else if ((moduleType & WOTModuleTypeRadios) == WOTModuleTypeRadios) {
        
        name = @"WOTModuleTypeRadios";
    } else if ((moduleType & WOTModuleTypeTurrets) == WOTModuleTypeTurrets) {
        
        name = @"WOTModuleTypeTurrets";
    }
    return name;
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

- (WOTModuleType) moduleType {

    return [self moduleTree].moduleType;
}

- (NSString *)moduleTypeString {
    
    return [WOTNode moduleTypeStringForModuleType:self.moduleType];
}

static const void *WOTModuleTree = &WOTModuleTree;
- (void)setModuleTree:(ModulesTree *)moduleTree {
    
    objc_setAssociatedObject(self, WOTModuleTree, moduleTree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ModulesTree *)moduleTree {

    return objc_getAssociatedObject(self, WOTModuleTree);
}

@end
