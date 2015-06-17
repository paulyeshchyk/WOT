//
//  Tankguns.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


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

@end
