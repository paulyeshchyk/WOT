//
//  Vehicles+CoreDataClass.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, Tankchassis, Tankengines, Tankguns, Tankradios, Tankturrets, Vehicleprofile;

NS_ASSUME_NONNULL_BEGIN

@interface Vehicles : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Vehicles+CoreDataProperties.h"
