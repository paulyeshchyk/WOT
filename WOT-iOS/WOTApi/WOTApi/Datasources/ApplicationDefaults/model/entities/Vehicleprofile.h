//
//  Vehicleprofile.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tanks, VehicleprofileAmmoList, VehicleprofileArmorList, VehicleprofileEngine, VehicleprofileGun, VehicleprofileRadio, VehicleprofileSuspension, VehicleprofileTurret;

@interface Vehicleprofile : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * hp;
@property (nonatomic, retain) NSDecimalNumber * hull_hp;
@property (nonatomic, retain) NSDecimalNumber * hull_weight;
@property (nonatomic, retain) NSNumber * is_default;
@property (nonatomic, retain) NSDecimalNumber * max_ammo;
@property (nonatomic, retain) NSDecimalNumber * max_weight;
@property (nonatomic, retain) NSDecimalNumber * speed_backward;
@property (nonatomic, retain) NSDecimalNumber * speed_forward;
@property (nonatomic, retain) NSDecimalNumber * tank_id;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSDecimalNumber * hashName;
@property (nonatomic, retain) VehicleprofileAmmoList *ammo;
@property (nonatomic, retain) VehicleprofileArmorList *armor;
@property (nonatomic, retain) VehicleprofileEngine *engine;
@property (nonatomic, retain) VehicleprofileGun *gun;
@property (nonatomic, retain) VehicleprofileRadio *radio;
@property (nonatomic, retain) VehicleprofileSuspension *suspension;
@property (nonatomic, retain) Tanks *tank;
@property (nonatomic, retain) VehicleprofileTurret *turret;

@end
