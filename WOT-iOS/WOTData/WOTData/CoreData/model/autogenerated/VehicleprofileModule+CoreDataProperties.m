//
//  VehicleprofileModule+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileModule+CoreDataProperties.h"

@implementation VehicleprofileModule (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileModule *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileModule"];
}

@dynamic engine_id;
@dynamic gun_id;
@dynamic radio_id;
@dynamic suspension_id;
@dynamic turret_id;
@dynamic vehicleProfile;
@dynamic tankradios;
@dynamic tankguns;
@dynamic tankengines;
@dynamic tankchassis;
@dynamic tankturrets;

@end
