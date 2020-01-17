//
//  Vehicles+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "Vehicles+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Vehicles (CoreDataProperties)

+ (NSFetchRequest<Vehicles *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *is_gift;
@property (nullable, nonatomic, copy) NSNumber *is_premium;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSNumber *price_credit;
@property (nullable, nonatomic, copy) NSNumber *price_gold;
@property (nullable, nonatomic, copy) NSString *short_name;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSDecimalNumber *tank_id;
@property (nullable, nonatomic, copy) NSDecimalNumber *tier;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) Vehicleprofile *default_profile;
@property (nullable, nonatomic, retain) NSSet<Tankengines *> *engines;
@property (nullable, nonatomic, retain) NSSet<Tankguns *> *guns;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *modules_tree;
@property (nullable, nonatomic, retain) NSSet<Tankradios *> *radios;
@property (nullable, nonatomic, retain) NSSet<Tankchassis *> *suspensions;
@property (nullable, nonatomic, retain) NSSet<Tankturrets *> *turrets;

@end

@interface Vehicles (CoreDataGeneratedAccessors)

- (void)addEnginesObject:(Tankengines *)value;
- (void)removeEnginesObject:(Tankengines *)value;
- (void)addEngines:(NSSet<Tankengines *> *)values;
- (void)removeEngines:(NSSet<Tankengines *> *)values;

- (void)addGunsObject:(Tankguns *)value;
- (void)removeGunsObject:(Tankguns *)value;
- (void)addGuns:(NSSet<Tankguns *> *)values;
- (void)removeGuns:(NSSet<Tankguns *> *)values;

- (void)addModules_treeObject:(ModulesTree *)value;
- (void)removeModules_treeObject:(ModulesTree *)value;
- (void)addModules_tree:(NSSet<ModulesTree *> *)values;
- (void)removeModules_tree:(NSSet<ModulesTree *> *)values;

- (void)addRadiosObject:(Tankradios *)value;
- (void)removeRadiosObject:(Tankradios *)value;
- (void)addRadios:(NSSet<Tankradios *> *)values;
- (void)removeRadios:(NSSet<Tankradios *> *)values;

- (void)addSuspensionsObject:(Tankchassis *)value;
- (void)removeSuspensionsObject:(Tankchassis *)value;
- (void)addSuspensions:(NSSet<Tankchassis *> *)values;
- (void)removeSuspensions:(NSSet<Tankchassis *> *)values;

- (void)addTurretsObject:(Tankturrets *)value;
- (void)removeTurretsObject:(Tankturrets *)value;
- (void)addTurrets:(NSSet<Tankturrets *> *)values;
- (void)removeTurrets:(NSSet<Tankturrets *> *)values;

@end

NS_ASSUME_NONNULL_END
