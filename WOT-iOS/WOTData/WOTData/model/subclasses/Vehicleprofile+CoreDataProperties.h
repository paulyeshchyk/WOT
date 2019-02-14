//
//  Vehicleprofile+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "Vehicleprofile+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Vehicleprofile (CoreDataProperties)

+ (NSFetchRequest<Vehicleprofile *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *hashName;
@property (nullable, nonatomic, copy) NSDecimalNumber *hp;
@property (nullable, nonatomic, copy) NSDecimalNumber *hull_hp;
@property (nullable, nonatomic, copy) NSDecimalNumber *hull_weight;
@property (nullable, nonatomic, copy) NSNumber *is_default;
@property (nullable, nonatomic, copy) NSDecimalNumber *max_ammo;
@property (nullable, nonatomic, copy) NSDecimalNumber *max_weight;
@property (nullable, nonatomic, copy) NSDecimalNumber *speed_backward;
@property (nullable, nonatomic, copy) NSDecimalNumber *speed_forward;
@property (nullable, nonatomic, copy) NSDecimalNumber *tank_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *weight;
@property (nullable, nonatomic, retain) VehicleprofileAmmoList *ammo;
@property (nullable, nonatomic, retain) VehicleprofileArmorList *armor;
@property (nullable, nonatomic, retain) VehicleprofileEngine *engine;
@property (nullable, nonatomic, retain) VehicleprofileGun *gun;
@property (nullable, nonatomic, retain) VehicleprofileRadio *radio;
@property (nullable, nonatomic, retain) VehicleprofileSuspension *suspension;
@property (nullable, nonatomic, retain) Tanks *tank;
@property (nullable, nonatomic, retain) VehicleprofileTurret *turret;

@end

NS_ASSUME_NONNULL_END
