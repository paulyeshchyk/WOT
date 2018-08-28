//
//  Vehicles+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
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
@dynamic radios;
@dynamic suspensions;
@dynamic tanks;
@dynamic turrets;

@end
