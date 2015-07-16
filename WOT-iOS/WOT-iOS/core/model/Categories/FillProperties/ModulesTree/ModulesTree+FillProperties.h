//
//  ModulesTree+FillProperties.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "ModulesTree.h"
typedef NS_ENUM(NSInteger, WOTModuleType){
    WOTModuleTypeUnknown  = 1 << 0,
    WOTModuleTypeEngine = 1 << 1,
    WOTModuleTypeChassis  = 1 << 2,
    WOTModuleTypeGuns = 1 << 3,
    WOTModuleTypeRadios = 1 << 4,
    WOTModuleTypeTurrets = 1 << 5,
    WOTModuleTypeTank = 1 << 6
};


@interface ModulesTree (FillProperties)

- (WOTModuleType)moduleType;

@end
