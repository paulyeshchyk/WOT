//
//  ModulesTree.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, Tankchassis, Tankengines, Tankguns, Tankradios, Tankturrets, Vehicles;

@interface ModulesTree : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price_xp;
@property (nonatomic, retain) NSDecimalNumber * price_credit;
@property (nonatomic, retain) NSDecimalNumber * module_id;
@property (nonatomic, retain) NSNumber * is_default;
@property (nonatomic, retain) NSSet *nextModules;
@property (nonatomic, retain) NSSet *nextTanks;
@property (nonatomic, retain) NSSet *nextChassis;
@property (nonatomic, retain) NSSet *nextEngines;
@property (nonatomic, retain) NSSet *nextGuns;
@property (nonatomic, retain) NSSet *nextRadios;
@property (nonatomic, retain) NSSet *nextTurrets;
@end

@interface ModulesTree (CoreDataGeneratedAccessors)

- (void)addNextModulesObject:(ModulesTree *)value;
- (void)removeNextModulesObject:(ModulesTree *)value;
- (void)addNextModules:(NSSet *)values;
- (void)removeNextModules:(NSSet *)values;

- (void)addNextTanksObject:(Vehicles *)value;
- (void)removeNextTanksObject:(Vehicles *)value;
- (void)addNextTanks:(NSSet *)values;
- (void)removeNextTanks:(NSSet *)values;

- (void)addNextChassisObject:(Tankchassis *)value;
- (void)removeNextChassisObject:(Tankchassis *)value;
- (void)addNextChassis:(NSSet *)values;
- (void)removeNextChassis:(NSSet *)values;

- (void)addNextEnginesObject:(Tankengines *)value;
- (void)removeNextEnginesObject:(Tankengines *)value;
- (void)addNextEngines:(NSSet *)values;
- (void)removeNextEngines:(NSSet *)values;

- (void)addNextGunsObject:(Tankguns *)value;
- (void)removeNextGunsObject:(Tankguns *)value;
- (void)addNextGuns:(NSSet *)values;
- (void)removeNextGuns:(NSSet *)values;

- (void)addNextRadiosObject:(Tankradios *)value;
- (void)removeNextRadiosObject:(Tankradios *)value;
- (void)addNextRadios:(NSSet *)values;
- (void)removeNextRadios:(NSSet *)values;

- (void)addNextTurretsObject:(Tankturrets *)value;
- (void)removeNextTurretsObject:(Tankturrets *)value;
- (void)addNextTurrets:(NSSet *)values;
- (void)removeNextTurrets:(NSSet *)values;

@end
