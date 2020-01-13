//
//  VehicleprofileAmmoPenetration+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "VehicleprofileAmmoPenetration+CoreDataProperties.h"

@implementation VehicleprofileAmmoPenetration (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmoPenetration *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VehicleprofileAmmoPenetration"];
}

@dynamic avg_value;
@dynamic max_value;
@dynamic min_value;
@dynamic vehicleprofileAmmo;

@end
