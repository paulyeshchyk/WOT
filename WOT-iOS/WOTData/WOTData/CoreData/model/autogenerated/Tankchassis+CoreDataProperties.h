//
//  Tankchassis+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankchassis+CoreDataClass.h"

@class VehicleprofileModule;

NS_ASSUME_NONNULL_BEGIN

@interface Tankchassis (CoreDataProperties)

+ (NSFetchRequest<Tankchassis *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *level;
@property (nullable, nonatomic, copy) NSNumber *max_load;
@property (nullable, nonatomic, copy) NSDecimalNumber *module_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_credit;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_gold;
@property (nullable, nonatomic, copy) NSDecimalNumber *rotation_speed;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *modulesTree;
@property (nullable, nonatomic, retain) NSSet<VehicleprofileSuspension *> *vehicleprofileSuspension;
@property (nullable, nonatomic, retain) NSSet<Vehicles *> *vehicles;
@property (nullable, nonatomic, retain) NSSet<VehicleprofileModule *> *profileModule;

@end

@interface Tankchassis (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet<ModulesTree *> *)values;
- (void)removeModulesTree:(NSSet<ModulesTree *> *)values;

- (void)addVehicleprofileSuspensionObject:(VehicleprofileSuspension *)value;
- (void)removeVehicleprofileSuspensionObject:(VehicleprofileSuspension *)value;
- (void)addVehicleprofileSuspension:(NSSet<VehicleprofileSuspension *> *)values;
- (void)removeVehicleprofileSuspension:(NSSet<VehicleprofileSuspension *> *)values;

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
