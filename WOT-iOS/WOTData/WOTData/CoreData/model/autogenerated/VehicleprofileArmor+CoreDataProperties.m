//
//  VehicleprofileArmor+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileArmor+CoreDataProperties.h"

@implementation VehicleprofileArmor (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileArmor *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileArmor"];
}

@dynamic front;
@dynamic rear;
@dynamic sides;
@dynamic vehicleprofileArmorListHull;
@dynamic vehicleprofileArmorListTurret;

@end
