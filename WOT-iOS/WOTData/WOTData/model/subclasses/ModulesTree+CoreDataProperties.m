//
//  ModulesTree+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "ModulesTree+CoreDataProperties.h"

@implementation ModulesTree (CoreDataProperties)

+ (NSFetchRequest<ModulesTree *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ModulesTree"];
}

@dynamic is_default;
@dynamic module_id;
@dynamic name;
@dynamic price_credit;
@dynamic price_xp;
@dynamic type;
@dynamic nextChassis;
@dynamic nextEngines;
@dynamic nextGuns;
@dynamic nextModules;
@dynamic nextRadios;
@dynamic nextTanks;
@dynamic nextTurrets;
@dynamic prevModules;

@end
