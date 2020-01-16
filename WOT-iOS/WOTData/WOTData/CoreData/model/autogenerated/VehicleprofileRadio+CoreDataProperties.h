//
//  VehicleprofileRadio+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileRadio+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileRadio (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileRadio *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDecimalNumber *signal_range;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSDecimalNumber *tier;
@property (nullable, nonatomic, copy) NSDecimalNumber *weight;
@property (nullable, nonatomic, retain) Tankradios *tankradio;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
