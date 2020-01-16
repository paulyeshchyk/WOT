//
//  Vehicles+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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
@dynamic modules_tree;
@dynamic radios;
@dynamic suspensions;
@dynamic turrets;

@end
