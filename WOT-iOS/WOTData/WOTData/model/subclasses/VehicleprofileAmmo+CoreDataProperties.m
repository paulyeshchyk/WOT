//
//  VehicleprofileAmmo+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileAmmo+CoreDataProperties.h"

@implementation VehicleprofileAmmo (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileAmmo"];
}

@dynamic ammoType;
@dynamic damage;
@dynamic penetration;
@dynamic vehicleprofileAmmoList;

@end
