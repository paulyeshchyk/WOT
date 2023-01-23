//
//  VehicleprofileEngine.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, Tankengines;

@interface VehicleprofileEngine : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * power;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDecimalNumber * fire_chance;
@property (nonatomic, retain) NSDecimalNumber * tier;
@property (nonatomic, retain) NSManagedObject *vehicleprofile;
@property (nonatomic, retain) Tankengines *tankengine;

@end
