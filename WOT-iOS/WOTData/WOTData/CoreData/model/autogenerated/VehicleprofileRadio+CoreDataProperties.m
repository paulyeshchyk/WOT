//
//  VehicleprofileRadio+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileRadio+CoreDataProperties.h"

@implementation VehicleprofileRadio (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileRadio *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileRadio"];
}

@dynamic name;
@dynamic signal_range;
@dynamic tag;
@dynamic tier;
@dynamic weight;
@dynamic tankradio;
@dynamic vehicleprofile;

@end
