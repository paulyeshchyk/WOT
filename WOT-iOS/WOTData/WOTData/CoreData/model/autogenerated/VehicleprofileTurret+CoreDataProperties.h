//
//  VehicleprofileTurret+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileTurret+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileTurret (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileTurret *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *view_range;
@property (nullable, nonatomic, copy) NSDecimalNumber *tier;
@property (nullable, nonatomic, copy) NSDecimalNumber *weight;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSDecimalNumber *traverse_right_arc;
@property (nullable, nonatomic, copy) NSDecimalNumber *traverse_left_arc;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDecimalNumber *hp;
@property (nullable, nonatomic, retain) Tankturrets *tankturrets;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
