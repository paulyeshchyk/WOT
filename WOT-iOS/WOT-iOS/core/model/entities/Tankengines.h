//
//  Tankengines.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicles;

@interface Tankengines : NSManagedObject

@property (nonatomic, retain) NSNumber * fire_starting_chance;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * price_credit;
@property (nonatomic, retain) NSNumber * price_gold;
@property (nonatomic, retain) NSSet *vehicles;
@end

@interface Tankengines (CoreDataGeneratedAccessors)

- (void)addVehiclesObject:(Vehicles *)value;
- (void)removeVehiclesObject:(Vehicles *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

@end
