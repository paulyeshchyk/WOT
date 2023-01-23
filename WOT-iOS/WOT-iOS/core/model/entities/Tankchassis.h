//
//  Tankchassis.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, VehicleprofileSuspension, Vehicles;

@interface Tankchassis : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * level;
@property (nonatomic, retain) NSNumber * max_load;
@property (nonatomic, retain) NSDecimalNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nation_i18n;
@property (nonatomic, retain) NSDecimalNumber * price_credit;
@property (nonatomic, retain) NSDecimalNumber * price_gold;
@property (nonatomic, retain) NSDecimalNumber * rotation_speed;
@property (nonatomic, retain) NSSet *modulesTree;
@property (nonatomic, retain) NSSet *vehicles;
@property (nonatomic, retain) NSSet *vehicleprofileSuspension;
@end

@interface Tankchassis (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet *)values;
- (void)removeModulesTree:(NSSet *)values;

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

- (void)addVehicleprofileSuspensionObject:(VehicleprofileSuspension *)value;
- (void)removeVehicleprofileSuspensionObject:(VehicleprofileSuspension *)value;
- (void)addVehicleprofileSuspension:(NSSet *)values;
- (void)removeVehicleprofileSuspension:(NSSet *)values;

@end
