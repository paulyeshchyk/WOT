//
//  ModulesTree+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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
@dynamic defaultProfile;
@dynamic nextChassis;
@dynamic nextEngines;
@dynamic nextGuns;
@dynamic nextModules;
@dynamic nextRadios;
@dynamic nextTurrets;
@dynamic prevModules;
@dynamic vehicles;

@end
