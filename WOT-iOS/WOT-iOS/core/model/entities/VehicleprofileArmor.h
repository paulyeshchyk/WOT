//
//  VehicleprofileArmor.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface VehicleprofileArmor : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * front;
@property (nonatomic, retain) NSDecimalNumber * sides;
@property (nonatomic, retain) NSDecimalNumber * rear;
@property (nonatomic, retain) NSManagedObject *vehicleprofileArmorListHull;
@property (nonatomic, retain) NSManagedObject *vehicleprofileArmorListTurret;

@end
