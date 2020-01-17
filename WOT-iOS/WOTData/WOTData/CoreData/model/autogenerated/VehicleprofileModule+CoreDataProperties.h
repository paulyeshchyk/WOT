//
//  VehicleprofileModule+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileModule+CoreDataClass.h"

@class Tankradios, Tankguns, Tankengines, Tankchassis, Tankturrets;

NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileModule (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileModule *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *engine_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *gun_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *radio_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *suspension_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *turret_id;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleProfile;
@property (nullable, nonatomic, retain) Tankradios *tankradios;
@property (nullable, nonatomic, retain) Tankguns *tankguns;
@property (nullable, nonatomic, retain) Tankengines *tankengines;
@property (nullable, nonatomic, retain) Tankchassis *tankchassis;
@property (nullable, nonatomic, retain) Tankturrets *tankturrets;

@end

NS_ASSUME_NONNULL_END
