//
//  WOTNode+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode+Tanks.h"

#import "ModulesTree+FillProperties.h"

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

    self = [self initWithName:module.name imageURL:imageURL];
    if (self){
        
    }
    return self;
}




@end
