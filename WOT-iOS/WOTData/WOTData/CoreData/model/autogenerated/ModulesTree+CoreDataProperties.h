//
//  ModulesTree+CoreDataProperties.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "ModulesTree+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ModulesTree (CoreDataProperties)

+ (NSFetchRequest<ModulesTree *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *is_default;
@property (nullable, nonatomic, copy) NSDecimalNumber *module_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_credit;
@property (nullable, nonatomic, copy) NSDecimalNumber *price_xp;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) NSSet<Tankchassis *> *nextChassis;
@property (nullable, nonatomic, retain) NSSet<Tankengines *> *nextEngines;
@property (nullable, nonatomic, retain) NSSet<Tankguns *> *nextGuns;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *nextModules;
@property (nullable, nonatomic, retain) NSSet<Tankradios *> *nextRadios;
@property (nullable, nonatomic, retain) NSSet<Tankturrets *> *nextTurrets;
@property (nullable, nonatomic, retain) ModulesTree *prevModules;
@property (nullable, nonatomic, retain) Vehicles *vehicles;
@property (nullable, nonatomic, retain) Vehicleprofile *defaultProfile;

@end

@interface ModulesTree (CoreDataGeneratedAccessors)

- (void)addNextChassisObject:(Tankchassis *)value;
- (void)removeNextChassisObject:(Tankchassis *)value;
- (void)addNextChassis:(NSSet<Tankchassis *> *)values;
- (void)removeNextChassis:(NSSet<Tankchassis *> *)values;

- (void)addNextEnginesObject:(Tankengines *)value;
- (void)removeNextEnginesObject:(Tankengines *)value;
- (void)addNextEngines:(NSSet<Tankengines *> *)values;
- (void)removeNextEngines:(NSSet<Tankengines *> *)values;

- (void)addNextGunsObject:(Tankguns *)value;
- (void)removeNextGunsObject:(Tankguns *)value;
- (void)addNextGuns:(NSSet<Tankguns *> *)values;
- (void)removeNextGuns:(NSSet<Tankguns *> *)values;

- (void)addNextModulesObject:(ModulesTree *)value;
- (void)removeNextModulesObject:(ModulesTree *)value;
- (void)addNextModules:(NSSet<ModulesTree *> *)values;
- (void)removeNextModules:(NSSet<ModulesTree *> *)values;

- (void)addNextRadiosObject:(Tankradios *)value;
- (void)removeNextRadiosObject:(Tankradios *)value;
- (void)addNextRadios:(NSSet<Tankradios *> *)values;
- (void)removeNextRadios:(NSSet<Tankradios *> *)values;

- (void)addNextTurretsObject:(Tankturrets *)value;
- (void)removeNextTurretsObject:(Tankturrets *)value;
- (void)addNextTurrets:(NSSet<Tankturrets *> *)values;
- (void)removeNextTurrets:(NSSet<Tankturrets *> *)values;

@end

NS_ASSUME_NONNULL_END
