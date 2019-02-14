//
//  Tanks+CoreDataProperties.m
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//
//

#import "Tanks+CoreDataProperties.h"

@implementation Tanks (CoreDataProperties)

+ (NSFetchRequest<Tanks *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tanks"];
}

@dynamic contour_image;
@dynamic image;
@dynamic image_small;
@dynamic is_premium;
@dynamic level;
@dynamic name;
@dynamic name_i18n;
@dynamic nation;
@dynamic nation_i18n;
@dynamic short_name_i18n;
@dynamic tank_id;
@dynamic type;
@dynamic type_i18n;
@dynamic modulesTree;
@dynamic vehicleprofiles;
@dynamic vehicles;

@end
