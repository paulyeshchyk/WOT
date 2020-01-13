//
//  VehicleprofileTurret+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "VehicleprofileTurret+CoreDataProperties.h"

@implementation VehicleprofileTurret (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileTurret *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileTurret"];
}

@dynamic tankturrets;
@dynamic vehicleprofile;

@end
