//
//  Tankturrets.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, NSManagedObject, Vehicles;

@interface Tankturrets : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * armor_board;
@property (nonatomic, retain) NSDecimalNumber * armor_fedd;
@property (nonatomic, retain) NSDecimalNumber * armor_forehead;
@property (nonatomic, retain) NSDecimalNumber * circular_vision_radius;
@property (nonatomic, retain) NSDecimalNumber * level;
@property (nonatomic, retain) NSDecimalNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSDecimalNumber * price_credit;
@property (nonatomic, retain) NSDecimalNumber * price_gold;
@property (nonatomic, retain) NSDecimalNumber * rotation_speed;
@property (nonatomic, retain) NSSet *modulesTree;
@property (nonatomic, retain) NSSet *vehicles;
@property (nonatomic, retain) NSManagedObject *vehicleprofileTurrets;
@end

@interface Tankturrets (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet *)values;
- (void)removeModulesTree:(NSSet *)values;

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

@end
