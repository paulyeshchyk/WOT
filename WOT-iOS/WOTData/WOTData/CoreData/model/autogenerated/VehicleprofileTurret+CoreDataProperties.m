//
//  VehicleprofileTurret+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileTurret+CoreDataProperties.h"

@implementation VehicleprofileTurret (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileTurret *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileTurret"];
}

@dynamic view_range;
@dynamic tier;
@dynamic weight;
@dynamic tag;
@dynamic traverse_right_arc;
@dynamic traverse_left_arc;
@dynamic name;
@dynamic hp;
@dynamic tankturrets;
@dynamic vehicleprofile;

@end
