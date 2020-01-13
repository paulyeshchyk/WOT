//
//  VehicleprofileAmmoList+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
