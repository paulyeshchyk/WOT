//
//  Tankturrets.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tankturrets : NSManagedObject

@property (nonatomic, retain) NSNumber * armor_board;
@property (nonatomic, retain) NSNumber * armor_fedd;
@property (nonatomic, retain) NSNumber * armor_forehead;
@property (nonatomic, retain) NSNumber * circular_vision_radius;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSNumber * price_credit;
@property (nonatomic, retain) NSNumber * price_gold;
@property (nonatomic, retain) NSNumber * rotation_speed;

@end
