//
//  VehicleprofileArmorList+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "VehicleprofileArmorList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileArmorList (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileArmorList *> *)fetchRequest;

@property (nullable, nonatomic, retain) VehicleprofileArmor *hull;
@property (nullable, nonatomic, retain) VehicleprofileArmor *turret;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
