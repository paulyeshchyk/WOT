//
//  Tankengines+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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
@dynamic nation;
@dynamic power;
@dynamic price_credit;
@dynamic price_gold;
@dynamic modulesTree;
@dynamic vehicleprofileEngines;
@dynamic vehicles;
@dynamic profileModule;

@end
