//
//  VehicleprofileTurret.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tankturrets, Vehicleprofile;

@interface VehicleprofileTurret : NSManagedObject

@property (nonatomic, retain) Vehicleprofile *vehicleprofile;
@property (nonatomic, retain) Tankturrets *tankturrets;

@end
