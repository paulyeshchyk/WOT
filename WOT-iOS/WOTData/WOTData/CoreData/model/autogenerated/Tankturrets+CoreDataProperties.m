//
//  Tankturrets+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
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

@end
