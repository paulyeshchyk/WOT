//
//  VehicleprofileAmmoDamage.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface VehicleprofileAmmoDamage : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * avg_value;
@property (nonatomic, retain) NSDecimalNumber * max_value;
@property (nonatomic, retain) NSDecimalNumber * min_value;
@property (nonatomic, retain) NSManagedObject *vehicleprofileAmmo;

@end
