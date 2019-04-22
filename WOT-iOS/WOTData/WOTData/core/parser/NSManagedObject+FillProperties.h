//
//  NSManagedObject+FillProperties.h
//  WOT-iOS
//
//  Created on 6/5/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (FillProperties)

+ (NSArray *)availableFields;
+ (NSArray *)availableLinks;
+ (NSArray *)embeddedLinks;

@end
