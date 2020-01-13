//
//  VehicleprofileAmmo+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "VehicleprofileAmmo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VehicleprofileAmmo (CoreDataProperties)

+ (NSFetchRequest<VehicleprofileAmmo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ammoType;
@property (nullable, nonatomic, retain) VehicleprofileAmmoDamage *damage;
@property (nullable, nonatomic, retain) VehicleprofileAmmoPenetration *penetration;
@property (nullable, nonatomic, retain) VehicleprofileAmmoList *vehicleprofileAmmoList;

@end

NS_ASSUME_NONNULL_END
