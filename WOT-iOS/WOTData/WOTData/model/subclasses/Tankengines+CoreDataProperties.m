//
//  Tankengines+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "Tankengines+CoreDataProperties.h"

@implementation Tankengines (CoreDataProperties)

+ (NSFetchRequest<Tankengines *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tankengines"];
}

@dynamic fire_starting_chance;
@dynamic level;
@dynamic module_id;
@dynamic name;
@dynamic name_i18n;
@dynamic nation;
@dynamic power;
@dynamic price_credit;
@dynamic price_gold;
@dynamic modulesTree;
@dynamic vehicleprofileEngines;
@dynamic vehicles;

@end
