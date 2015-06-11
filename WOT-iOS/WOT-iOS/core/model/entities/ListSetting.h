//
//  ListSetting.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/11/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListSetting : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * ascending;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * orderBy;
@property (nonatomic, retain) NSString * values;

@end
