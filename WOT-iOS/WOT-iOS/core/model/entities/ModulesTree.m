//
//  ModulesTree.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "ModulesTree.h"
#import "ModulesTree.h"
#import "Tankchassis.h"
#import "Tankengines.h"
#import "Tankguns.h"
#import "Tankradios.h"
#import "Tanks.h"
#import "Tankturrets.h"


@implementation ModulesTree

@dynamic type;
@dynamic name;
@dynamic price_xp;
@dynamic price_credit;
@dynamic module_id;
@dynamic is_default;
@dynamic nextModules;
@dynamic nextTanks;
@dynamic nextChassis;
@dynamic nextEngines;
@dynamic nextGuns;
@dynamic nextRadios;
@dynamic nextTurrets;
@dynamic prevModules;

@end
