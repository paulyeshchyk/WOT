//
//  VehicleprofileEngine+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
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
