//
//  Vehicles.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tankengines;

@interface Vehicles : NSManagedObject

@property (nonatomic, retain) NSNumber * is_gift;
@property (nonatomic, retain) NSNumber * is_premium;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSNumber * price_credit;
@property (nonatomic, retain) NSNumber * price_gold;
@property (nonatomic, retain) NSNumber * prices_xp;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSNumber * tank_id;
@property (nonatomic, retain) NSNumber * tier;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *engines;
@end

@interface Vehicles (CoreDataGeneratedAccessors)

- (void)addEnginesObject:(Tankengines *)value;
- (void)removeEnginesObject:(Tankengines *)value;
- (void)addEngines:(NSSet *)values;
- (void)removeEngines:(NSSet *)values;

@end
