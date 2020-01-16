//
//  VehicleprofileSuspension+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileSuspension+CoreDataProperties.h"

@implementation VehicleprofileSuspension (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileSuspension *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileSuspension"];
}

@dynamic load_limit;
@dynamic name;
@dynamic tag;
@dynamic tier;
@dynamic traverse_speed;
@dynamic weight;
@dynamic tankchassis;
@dynamic vehicleprofile;

@end
