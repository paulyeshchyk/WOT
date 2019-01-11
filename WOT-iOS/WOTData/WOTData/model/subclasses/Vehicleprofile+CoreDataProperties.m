//
//  Vehicleprofile+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "Vehicleprofile+CoreDataProperties.h"

@implementation Vehicleprofile (CoreDataProperties)

+ (NSFetchRequest<Vehicleprofile *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Vehicleprofile"];
}

@dynamic hashName;
@dynamic hp;
@dynamic hull_hp;
@dynamic hull_weight;
@dynamic is_default;
@dynamic max_ammo;
@dynamic max_weight;
@dynamic speed_backward;
@dynamic speed_forward;
@dynamic tank_id;
@dynamic weight;
@dynamic ammo;
@dynamic armor;
@dynamic engine;
@dynamic gun;
@dynamic radio;
@dynamic suspension;
@dynamic tank;
@dynamic turret;

@end