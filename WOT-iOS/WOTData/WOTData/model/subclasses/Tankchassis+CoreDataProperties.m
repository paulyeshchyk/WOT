//
//  Tankchassis+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankchassis+CoreDataProperties.h"

@implementation Tankchassis (CoreDataProperties)

+ (NSFetchRequest<Tankchassis *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tankchassis"];
}

@dynamic level;
@dynamic max_load;
@dynamic module_id;
@dynamic name;
@dynamic name_i18n;
@dynamic nation;
@dynamic nation_i18n;
@dynamic price_credit;
@dynamic price_gold;
@dynamic rotation_speed;
@dynamic modulesTree;
@dynamic vehicleprofileSuspension;
@dynamic vehicles;

@end
