//
//  VehicleprofileModule+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileModule+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileModule (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileModule *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *suspension_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *gun_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *radio_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *engine_id;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleProfile;

@end

NS_ASSUME_NONNULL_END
