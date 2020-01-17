//
//  Tankengines+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankengines+CoreDataClass.h"

@class VehicleprofileModule;

NS_ASSUME_NONNULL_BEGIN

@interface Tankengines (CoreDataProperties)

+ (NSFetchRequest<Tankengines *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *fire_starting_chance;
@property (nullable, nonatomic, copy) NSDecimalNumber *level;
@property (nullable, nonatomic, copy) NSDecimalNumber *module_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSDecimalNumber *power;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_credit;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_gold;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *modulesTree;
@property (nullable, nonatomic, retain) NSSet<VehicleprofileEngine *> *vehicleprofileEngines;
@property (nullable, nonatomic, retain) NSSet<Vehicles *> *vehicles;
@property (nullable, nonatomic, retain) NSSet<VehicleprofileModule *> *profileModule;

@end

@interface Tankengines (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet<ModulesTree *> *)values;
- (void)removeModulesTree:(NSSet<ModulesTree *> *)values;

- (void)addVehicleprofileEnginesObject:(VehicleprofileEngine *)value;
- (void)removeVehicleprofileEnginesObject:(VehicleprofileEngine *)value;
- (void)addVehicleprofileEngines:(NSSet<VehicleprofileEngine *> *)values;
- (void)removeVehicleprofileEngines:(NSSet<VehicleprofileEngine *> *)values;

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet<Vehicles *> *)values;
- (void)removeVehicles:(NSSet<Vehicles *> *)values;

- (void)addProfileModuleObject:(VehicleprofileModule *)value;
- (void)removeProfileModuleObject:(VehicleprofileModule *)value;
- (void)addProfileModule:(NSSet<VehicleprofileModule *> *)values;
- (void)removeProfileModule:(NSSet<VehicleprofileModule *> *)values;

@end

NS_ASSUME_NONNULL_END
