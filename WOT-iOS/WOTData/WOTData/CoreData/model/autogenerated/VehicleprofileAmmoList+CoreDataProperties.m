//
//  VehicleprofileAmmoList+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileAmmoList+CoreDataProperties.h"

@implementation VehicleprofileAmmoList (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmoList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileAmmoList"];
}

@dynamic vehicleprofile;
@dynamic vehicleprofileAmmo;

@end
