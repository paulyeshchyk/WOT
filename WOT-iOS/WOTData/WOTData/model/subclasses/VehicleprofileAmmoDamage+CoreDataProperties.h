//
//  VehicleprofileAmmoDamage+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileAmmoDamage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileAmmoDamage (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmoDamage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *avg_value;
@property (nullable, nonatomic, copy) NSDecimalNumber *max_value;
@property (nullable, nonatomic, copy) NSDecimalNumber *min_value;
@property (nullable, nonatomic, retain) VehicleprofileAmmo *vehicleprofileAmmo;

@end

NS_ASSUME_NONNULL_END
