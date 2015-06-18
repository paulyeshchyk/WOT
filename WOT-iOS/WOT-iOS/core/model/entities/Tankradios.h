//
//  Tankradios.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tankradios : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * module_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nation_i18n;
@property (nonatomic, retain) NSNumber * price_credit;
@property (nonatomic, retain) NSNumber * price_gold;

@end
