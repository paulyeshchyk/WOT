//
//  Tanks.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tanks : NSManagedObject

@property (nonatomic, retain) NSString * contour_image;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * image_small;
@property (nonatomic, retain) NSNumber * is_premium;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name_i18n;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nation_i18n;
@property (nonatomic, retain) NSString * short_name_i18n;
@property (nonatomic, retain) NSDecimalNumber * tank_id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * type_i18n;

@end
