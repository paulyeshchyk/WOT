//
//  VehicleprofileGun+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileGun+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileGun (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileGun *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *aim_time;
@property (nullable, nonatomic, copy) NSDecimalNumber *caliber;
@property (nullable, nonatomic, copy) NSDecimalNumber *dispersion;
@property (nullable, nonatomic, copy) NSDecimalNumber *fire_rate;
@property (nullable, nonatomic, copy) NSDecimalNumber *move_down_arc;
@property (nullable, nonatomic, copy) NSDecimalNumber *move_up_arc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDecimalNumber *reload_time;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSDecimalNumber *tier;
@property (nullable, nonatomic, copy) NSDecimalNumber *weight;
@property (nullable, nonatomic, retain) Tankguns *tankgun;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
