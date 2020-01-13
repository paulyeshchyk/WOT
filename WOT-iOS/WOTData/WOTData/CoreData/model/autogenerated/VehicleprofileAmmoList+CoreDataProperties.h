//
//  VehicleprofileAmmoList+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "VehicleprofileAmmoList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileAmmoList (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmoList *> *)fetchRequest;

@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;
@property (nullable, nonatomic, retain) NSSet<VehicleprofileAmmo *> *vehicleprofileAmmo;

@end

@interface VehicleprofileAmmoList (CoreDataGeneratedAccessors)

- (void)addVehicleprofileAmmoObject:(VehicleprofileAmmo *)value;
- (void)removeVehicleprofileAmmoObject:(VehicleprofileAmmo *)value;
- (void)addVehicleprofileAmmo:(NSSet<VehicleprofileAmmo *> *)values;
- (void)removeVehicleprofileAmmo:(NSSet<VehicleprofileAmmo *> *)values;

@end

NS_ASSUME_NONNULL_END
