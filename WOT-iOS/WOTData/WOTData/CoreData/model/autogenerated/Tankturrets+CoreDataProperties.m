//
//  Tankturrets+CoreDataProperties.m
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tankturrets+CoreDataProperties.h"

@implementation Tankturrets (CoreDataProperties)

+ (NSFetchRequest<Tankturrets *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tankturrets"];
}

@dynamic armor_board;
@dynamic armor_fedd;
@dynamic armor_forehead;
@dynamic circular_vision_radius;
@dynamic level;
@dynamic module_id;
@dynamic name;
@dynamic nation;
@dynamic price_credit;
@dynamic price_gold;
@dynamic rotation_speed;
@dynamic modulesTree;
@dynamic vehicleprofileTurrets;
@dynamic vehicles;
@dynamic profileModule;

@end
