//
//  Vehicleprofile+CoreDataClass.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tanks, VehicleprofileAmmoList, VehicleprofileArmorList, VehicleprofileEngine, VehicleprofileGun, VehicleprofileRadio, VehicleprofileSuspension, VehicleprofileTurret;

NS_ASSUME_NONNULL_BEGIN

@interface Vehicleprofile : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Vehicleprofile+CoreDataProperties.h"
