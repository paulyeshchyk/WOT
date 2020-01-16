//
//  VehicleprofileModule+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileModule+CoreDataProperties.h"

@implementation VehicleprofileModule (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileModule *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileModule"];
}

@dynamic suspension_id;
@dynamic gun_id;
@dynamic radio_id;
@dynamic engine_id;
@dynamic vehicleProfile;

@end
