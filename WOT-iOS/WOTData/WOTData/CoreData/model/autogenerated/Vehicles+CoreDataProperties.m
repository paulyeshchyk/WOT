//
//  Vehicles+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//
//

#import "Vehicles+CoreDataProperties.h"

@implementation Vehicles (CoreDataProperties)

+ (NSFetchRequest<Vehicles *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Vehicles"];
}

@dynamic is_gift;
@dynamic is_premium;
@dynamic name;
@dynamic nation;
@dynamic price_credit;
@dynamic price_gold;
@dynamic short_name;
@dynamic tag;
@dynamic tank_id;
@dynamic tier;
@dynamic type;
@dynamic default_profile;
@dynamic engines;
@dynamic guns;
@dynamic modulesTree;
@dynamic radios;
@dynamic suspensions;
@dynamic turrets;

@end
