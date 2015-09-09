//
//  Tankguns.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModulesTree, VehicleprofileGun, Vehicles;

@interface Tankguns : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * level;
@property (nonatomic, retain) NSDecimalNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nation_i18n;
@property (nonatomic, retain) NSDecimalNumber * price_credit;
@property (nonatomic, retain) NSDecimalNumber * price_gold;
@property (nonatomic, retain) NSDecimalNumber * rate;
@property (nonatomic, retain) NSSet *modulesTree;
@property (nonatomic, retain) NSSet *vehicles;
@property (nonatomic, retain) NSSet *vehicleprofileGun;
@end

@interface Tankguns (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet *)values;
- (void)removeModulesTree:(NSSet *)values;

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

- (void)addVehicleprofileGunObject:(VehicleprofileGun *)value;
- (void)removeVehicleprofileGunObject:(VehicleprofileGun *)value;
- (void)addVehicleprofileGun:(NSSet *)values;
- (void)removeVehicleprofileGun:(NSSet *)values;

@end
