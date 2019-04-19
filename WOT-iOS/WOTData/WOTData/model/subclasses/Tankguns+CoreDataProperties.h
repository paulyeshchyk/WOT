//
//  Tankguns+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "Tankguns+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tankguns (CoreDataProperties)

+ (NSFetchRequest<Tankguns *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDecimalNumber *level;
@property (nullable, nonatomic, copy) NSDecimalNumber *module_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_credit;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_gold;
@property (nullable, nonatomic, copy) NSDecimalNumber *rate;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *modulesTree;
@property (nullable, nonatomic, retain) NSSet<VehicleprofileGun *> *vehicleprofileGun;
@property (nullable, nonatomic, retain) NSSet<Vehicles *> *vehicles;

@end

@interface Tankguns (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet<ModulesTree *> *)values;
- (void)removeModulesTree:(NSSet<ModulesTree *> *)values;

- (void)addVehicleprofileGunObject:(VehicleprofileGun *)value;
- (void)removeVehicleprofileGunObject:(VehicleprofileGun *)value;
- (void)addVehicleprofileGun:(NSSet<VehicleprofileGun *> *)values;
- (void)removeVehicleprofileGun:(NSSet<VehicleprofileGun *> *)values;

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet<Vehicles *> *)values;
- (void)removeVehicles:(NSSet<Vehicles *> *)values;

@end

NS_ASSUME_NONNULL_END
