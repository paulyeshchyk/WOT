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
    WOTModuleTypeChassis  = 1 << 1,
    WOTModuleTypeEngine = 1 << 2,
    WOTModuleTypeRadios = 1 << 3,
    WOTModuleTypeTurrets = 1 << 4,
    WOTModuleTypeGuns = 1 << 5,
    WOTModuleTypeTank = 1 << 6
};


@interface ModulesTree (FillProperties)

- (WOTModuleType)moduleType;

@end
