//
//  VehicleprofileArmor+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileArmor+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileArmor (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileArmor *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *front;
@property (nullable, nonatomic, copy) NSDecimalNumber *rear;
@property (nullable, nonatomic, copy) NSDecimalNumber *sides;
@property (nullable, nonatomic, retain) VehicleprofileArmorList *vehicleprofileArmorListHull;
@property (nullable, nonatomic, retain) VehicleprofileArmorList *vehicleprofileArmorListTurret;

@end

NS_ASSUME_NONNULL_END
