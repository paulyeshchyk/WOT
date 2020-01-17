//
//  VehicleprofileArmorList+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileArmorList+CoreDataProperties.h"

@implementation VehicleprofileArmorList (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileArmorList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileArmorList"];
}

@dynamic hull;
@dynamic turret;
@dynamic vehicleprofile;

@end
