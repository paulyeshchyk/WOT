//
//  VehicleprofileGun.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, Tankguns;

@interface VehicleprofileGun : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * move_down_arc;
@property (nonatomic, retain) NSDecimalNumber * caliber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSDecimalNumber * move_up_arc;
@property (nonatomic, retain) NSDecimalNumber * fire_rate;
@property (nonatomic, retain) NSDecimalNumber * dispersion;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDecimalNumber * reload_time;
@property (nonatomic, retain) NSDecimalNumber * tier;
@property (nonatomic, retain) NSDecimalNumber * aim_time;
@property (nonatomic, retain) NSManagedObject *vehicleprofile;
@property (nonatomic, retain) Tankguns *tankgun;

@end
