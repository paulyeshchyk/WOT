//
//  VehicleprofileAmmoList+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
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
