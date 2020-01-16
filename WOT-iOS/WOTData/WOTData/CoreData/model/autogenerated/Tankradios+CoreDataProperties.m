//
//  Tankradios+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankradios+CoreDataProperties.h"

@implementation Tankradios (CoreDataProperties)

+ (NSFetchRequest<Tankradios *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tankradios"];
}

@dynamic distance;
@dynamic level;
@dynamic module_id;
@dynamic name;
@dynamic nation;
@dynamic price_credit;
@dynamic price_gold;
@dynamic modulesTree;
@dynamic vehicleprofileRadio;
@dynamic vehicles;

@end
