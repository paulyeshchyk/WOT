//
//  VehicleprofileArmorList+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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
