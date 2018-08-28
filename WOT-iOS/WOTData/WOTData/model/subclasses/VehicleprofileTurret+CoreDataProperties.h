//
//  VehicleprofileTurret+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileTurret+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileTurret (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileTurret *> *)fetchRequest;

@property (nullable, nonatomic, retain) Tankturrets *tankturrets;
@property (nullable, nonatomic, retain) Vehicleprofile *vehicleprofile;

@end

NS_ASSUME_NONNULL_END
