//
//  Vehicles.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/13/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, Tankchassis, Tankengines, Tankguns, Tankradios, Tanks, Tankturrets;

@interface Vehicles : NSManagedObject

@property (nonatomic, retain) NSNumber * is_gift;
@property (nonatomic, retain) NSNumber * is_premium;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSNumber * price_credit;
@property (nonatomic, retain) NSNumber * price_gold;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDecimalNumber * tank_id;
@property (nonatomic, retain) NSDecimalNumber * tier;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *engines;
@property (nonatomic, retain) NSSet *guns;
@property (nonatomic, retain) NSSet *radios;
@property (nonatomic, retain) NSSet *suspensions;
@property (nonatomic, retain) Tanks *tanks;
@property (nonatomic, retain) NSSet *turrets;
@property (nonatomic, retain) NSSet *modulesTree;
@end

@interface Vehicles (CoreDataGeneratedAccessors)

- (void)addEnginesObject:(Tankengines *)value;
- (void)removeEnginesObject:(Tankengines *)value;
- (void)addEngines:(NSSet *)values;
- (void)removeEngines:(NSSet *)values;

- (void)addGunsObject:(Tankguns *)value;
- (void)removeGunsObject:(Tankguns *)value;
- (void)addGuns:(NSSet *)values;
- (void)removeGuns:(NSSet *)values;

- (void)addRadiosObject:(Tankradios *)value;
- (void)removeRadiosObject:(Tankradios *)value;
- (void)addRadios:(NSSet *)values;
- (void)removeRadios:(NSSet *)values;

- (void)addSuspensionsObject:(Tankchassis *)value;
- (void)removeSuspensionsObject:(Tankchassis *)value;
- (void)addSuspensions:(NSSet *)values;
- (void)removeSuspensions:(NSSet *)values;

- (void)addTurretsObject:(Tankturrets *)value;
- (void)removeTurretsObject:(Tankturrets *)value;
- (void)addTurrets:(NSSet *)values;
- (void)removeTurrets:(NSSet *)values;

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet *)values;
- (void)removeModulesTree:(NSSet *)values;

@end
