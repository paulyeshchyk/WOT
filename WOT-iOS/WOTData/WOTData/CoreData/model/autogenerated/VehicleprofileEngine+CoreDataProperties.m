//
//  VehicleprofileEngine+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileEngine+CoreDataProperties.h"

@implementation VehicleprofileEngine (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileEngine *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileEngine"];
}

@dynamic fire_chance;
@dynamic name;
@dynamic power;
@dynamic tag;
@dynamic tier;
@dynamic weight;
@dynamic tankengine;
@dynamic vehicleprofile;

@end
