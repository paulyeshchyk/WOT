//
//  VehicleprofileSuspension+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
