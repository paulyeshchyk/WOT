//
//  Tankguns+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankguns+CoreDataProperties.h"

@implementation Tankguns (CoreDataProperties)

+ (NSFetchRequest<Tankguns *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tankguns"];
}

@dynamic level;
@dynamic module_id;
@dynamic name;
@dynamic nation;
@dynamic price_credit;
@dynamic price_gold;
@dynamic rate;
@dynamic modulesTree;
@dynamic vehicleprofileGun;
@dynamic vehicles;

@end
