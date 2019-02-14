//
//  VehicleprofileSuspension+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "VehicleprofileSuspension+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileSuspension (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileSuspension *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *load_limit;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSDecimalNumber *tier;
@property (nullable, nonatomic, copy) NSDecimalNumber *traverse_speed;
@property (nullable, nonatomic, copy) NSDecimalNumber *weight;
@property (nullable, nonatomic, retain) Tankchassis *tankchassis;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
