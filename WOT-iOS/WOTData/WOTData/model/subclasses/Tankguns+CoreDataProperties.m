//
//  Tankguns+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
@dynamic name_i18n;
@dynamic nation;
@dynamic nation_i18n;
@dynamic price_credit;
@dynamic price_gold;
@dynamic rate;
@dynamic modulesTree;
@dynamic vehicleprofileGun;
@dynamic vehicles;

@end
