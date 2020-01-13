//
//  VehicleprofileArmor+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
