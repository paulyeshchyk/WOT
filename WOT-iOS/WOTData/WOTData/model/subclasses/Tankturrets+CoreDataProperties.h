//
//  Tankturrets+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "Tankturrets+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tankturrets (CoreDataProperties)

+ (NSFetchRequest<Tankturrets *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *armor_board;
@property (nullable, nonatomic, copy) NSDecimalNumber *armor_fedd;
@property (nullable, nonatomic, copy) NSDecimalNumber *armor_forehead;
@property (nullable, nonatomic, copy) NSDecimalNumber *circular_vision_radius;
@property (nullable, nonatomic, copy) NSDecimalNumber *level;
@property (nullable, nonatomic, copy) NSDecimalNumber *module_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_credit;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_gold;
@property (nullable, nonatomic, copy) NSDecimalNumber *rotation_speed;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *modulesTree;
@property (nullable, nonatomic, retain) VehicleprofileTurret *vehicleprofileTurrets;
@property (nullable, nonatomic, retain) NSSet<Vehicles *> *vehicles;

@end

@interface Tankturrets (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet<ModulesTree *> *)values;
- (void)removeModulesTree:(NSSet<ModulesTree *> *)values;

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet<Vehicles *> *)values;
- (void)removeVehicles:(NSSet<Vehicles *> *)values;

@end

NS_ASSUME_NONNULL_END
