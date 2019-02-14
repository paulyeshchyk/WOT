//
//  ModulesTree+CoreDataClass.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tankchassis, Tankengines, Tankguns, Tankradios, Tanks, Tankturrets;

NS_ASSUME_NONNULL_BEGIN

@interface ModulesTree : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "ModulesTree+CoreDataProperties.h"
