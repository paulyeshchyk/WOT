//
//  VehicleprofileSuspension.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tankchassis, Vehicleprofile;

@interface VehicleprofileSuspension : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSDecimalNumber * load_limit;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDecimalNumber * traverse_speed;
@property (nonatomic, retain) NSDecimalNumber * tier;
@property (nonatomic, retain) Vehicleprofile *vehicleprofile;
@property (nonatomic, retain) Tankchassis *tankchassis;

@end
