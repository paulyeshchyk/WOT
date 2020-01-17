//
//  VehicleprofileGun+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileGun+CoreDataProperties.h"

@implementation VehicleprofileGun (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileGun *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileGun"];
}

@dynamic aim_time;
@dynamic caliber;
@dynamic dispersion;
@dynamic fire_rate;
@dynamic move_down_arc;
@dynamic move_up_arc;
@dynamic name;
@dynamic reload_time;
@dynamic tag;
@dynamic tier;
@dynamic weight;
@dynamic tankgun;
@dynamic vehicleprofile;

@end
