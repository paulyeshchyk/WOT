//
//  Tankradios+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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
@dynamic nation;
@dynamic price_credit;
@dynamic price_gold;
@dynamic modulesTree;
@dynamic vehicleprofileRadio;
@dynamic vehicles;

@end
