//
//  VehicleprofileArmorList.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicleprofile, VehicleprofileArmor;

@interface VehicleprofileArmorList : NSManagedObject

@property (nonatomic, retain) VehicleprofileArmor *hull;
@property (nonatomic, retain) VehicleprofileArmor *turret;
@property (nonatomic, retain) Vehicleprofile *vehicleprofile;

@end
