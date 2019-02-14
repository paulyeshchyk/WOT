//
//  ListSetting+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "ListSetting+CoreDataProperties.h"

@implementation ListSetting (CoreDataProperties)

+ (NSFetchRequest<ListSetting *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ListSetting"];
}

@dynamic ascending;
@dynamic key;
@dynamic orderBy;
@dynamic type;
@dynamic values;

@end
