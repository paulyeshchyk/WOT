//
//  Vehicles+CoreDataClass.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tankchassis, Tankengines, Tankguns, Tankradios, Tanks, Tankturrets, Vehicleprofile;

NS_ASSUME_NONNULL_BEGIN

@interface Vehicles : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Vehicles+CoreDataProperties.h"
