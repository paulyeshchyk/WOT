//
//  VehicleprofileAmmoDamage+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileAmmoDamage+CoreDataProperties.h"

@implementation VehicleprofileAmmoDamage (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmoDamage *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileAmmoDamage"];
}

@dynamic avg_value;
@dynamic max_value;
@dynamic min_value;
@dynamic vehicleprofileAmmo;

@end
