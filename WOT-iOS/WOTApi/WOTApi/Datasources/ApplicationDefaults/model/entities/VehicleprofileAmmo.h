//
//  VehicleprofileAmmo.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/9/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VehicleprofileAmmoDamage, VehicleprofileAmmoList, VehicleprofileAmmoPenetration;

@interface VehicleprofileAmmo : NSManagedObject

@property (nonatomic, retain) NSString * ammoType;
@property (nonatomic, retain) VehicleprofileAmmoList *vehicleprofileAmmoList;
@property (nonatomic, retain) VehicleprofileAmmoDamage *damage;
@property (nonatomic, retain) VehicleprofileAmmoPenetration *penetration;

@end
