//
//  Vehicleprofile+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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
@property (nullable, nonatomic, retain) ModulesTree *modulesTree;
@property (nullable, nonatomic, retain) VehicleprofileRadio *radio;
@property (nullable, nonatomic, retain) VehicleprofileSuspension *suspension;
@property (nullable, nonatomic, retain) VehicleprofileTurret *turret;
@property (nullable, nonatomic, retain) Vehicles *vehicles;
@property (nullable, nonatomic, retain) VehicleprofileModule *modules;

@end

NS_ASSUME_NONNULL_END
