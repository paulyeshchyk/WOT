//
//  VehicleprofileAmmo+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "VehicleprofileAmmo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileAmmo (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) VehicleprofileAmmoDamage *damage;
@property (nullable, nonatomic, retain) VehicleprofileAmmoPenetration *penetration;
@property (nullable, nonatomic, retain) VehicleprofileAmmoList *vehicleprofileAmmoList;

@end

NS_ASSUME_NONNULL_END
