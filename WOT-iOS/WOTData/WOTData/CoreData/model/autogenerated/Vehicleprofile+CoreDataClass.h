//
//  Vehicleprofile+CoreDataClass.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, VehicleprofileAmmoList, VehicleprofileArmorList, VehicleprofileEngine, VehicleprofileGun, VehicleprofileRadio, VehicleprofileSuspension, VehicleprofileTurret, Vehicles, VehicleprofileModule;

NS_ASSUME_NONNULL_BEGIN

@interface Vehicleprofile : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Vehicleprofile+CoreDataProperties.h"
