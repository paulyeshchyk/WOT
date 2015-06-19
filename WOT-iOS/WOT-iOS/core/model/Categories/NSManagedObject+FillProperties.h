//
//  NSManagedObject+FillProperties.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/5/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (FillProperties)

- (void)fillPropertiesFromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)availableFields;
+ (NSArray *)availableLinks;

@end
