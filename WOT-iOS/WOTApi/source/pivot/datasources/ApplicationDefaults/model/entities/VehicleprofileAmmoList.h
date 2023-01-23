//
//  VehicleprofileAmmoList.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface VehicleprofileAmmoList : NSManagedObject

@property (nonatomic, retain) NSSet *vehicleprofileAmmo;
@property (nonatomic, retain) NSManagedObject *vehicleprofile;
@end

@interface VehicleprofileAmmoList (CoreDataGeneratedAccessors)

- (void)addVehicleprofileAmmoObject:(NSManagedObject *)value;
- (void)removeVehicleprofileAmmoObject:(NSManagedObject *)value;
- (void)addVehicleprofileAmmo:(NSSet *)values;
- (void)removeVehicleprofileAmmo:(NSSet *)values;

@end
