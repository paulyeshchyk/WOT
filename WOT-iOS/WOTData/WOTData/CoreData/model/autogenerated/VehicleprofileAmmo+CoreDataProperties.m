//
//  VehicleprofileAmmo+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileAmmo+CoreDataProperties.h"

@implementation VehicleprofileAmmo (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileAmmo"];
}

@dynamic type;
@dynamic damage;
@dynamic penetration;
@dynamic vehicleprofileAmmoList;

@end
