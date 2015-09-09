//
//  VehicleprofileRadio.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tankradios, Vehicleprofile;

@interface VehicleprofileRadio : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * tier;
@property (nonatomic, retain) NSDecimalNumber * signal_range;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) Vehicleprofile *vehicleprofile;
@property (nonatomic, retain) Tankradios *tankradio;

@end
