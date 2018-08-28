//
//  Tankradios+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankradios+CoreDataProperties.h"

@implementation Tankradios (CoreDataProperties)

+ (NSFetchRequest<Tankradios *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tankradios"];
}

@dynamic distance;
@dynamic level;
@dynamic module_id;
@dynamic name;
@dynamic name_i18n;
@dynamic nation;
@dynamic nation_i18n;
@dynamic price_credit;
@dynamic price_gold;
@dynamic modulesTree;
@dynamic vehicleprofileRadio;
@dynamic vehicles;

@end
