//
//  Tankradios.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/10/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, Vehicles;

@interface Tankradios : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * distance;
@property (nonatomic, retain) NSDecimalNumber * level;
@property (nonatomic, retain) NSDecimalNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nation_i18n;
@property (nonatomic, retain) NSDecimalNumber * price_credit;
@property (nonatomic, retain) NSDecimalNumber * price_gold;
@property (nonatomic, retain) NSSet *vehicles;
@property (nonatomic, retain) NSSet *modulesTree;
@end

@interface Tankradios (CoreDataGeneratedAccessors)

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

- (void)addModulesTreeObject:(NSManagedObject *)value;
- (void)removeModulesTreeObject:(NSManagedObject *)value;
- (void)addModulesTree:(NSSet *)values;
- (void)removeModulesTree:(NSSet *)values;

@end
