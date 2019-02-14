//
//  VehicleprofileArmorList+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
