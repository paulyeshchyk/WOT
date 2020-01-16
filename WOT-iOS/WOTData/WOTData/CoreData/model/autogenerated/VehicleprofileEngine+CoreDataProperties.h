//
//  VehicleprofileEngine+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileEngine+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileEngine (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileEngine *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *fire_chance;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDecimalNumber *power;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSDecimalNumber *tier;
@property (nullable, nonatomic, copy) NSDecimalNumber *weight;
@property (nullable, nonatomic, retain) Tankengines *tankengine;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
