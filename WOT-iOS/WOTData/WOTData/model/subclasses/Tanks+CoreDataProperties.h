//
//  Tanks+CoreDataProperties.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//
//

#import "Tanks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tanks (CoreDataProperties)

+ (NSFetchRequest<Tanks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contour_image;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *image_small;
@property (nullable, nonatomic, copy) NSNumber *is_premium;
@property (nullable, nonatomic, copy) NSDecimalNumber *level;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *name_i18n;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSString *nation_i18n;
@property (nullable, nonatomic, copy) NSString *short_name_i18n;
@property (nullable, nonatomic, copy) NSDecimalNumber *tank_id;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *type_i18n;
@property (nullable, nonatomic, retain) NSSet<ModulesTree *> *modulesTree;
@property (nullable, nonatomic, retain) NSSet<Vehicleprofile *> *vehicleprofiles;
@property (nullable, nonatomic, retain) Vehicles *vehicles;

@end

@interface Tanks (CoreDataGeneratedAccessors)

- (void)addModulesTreeObject:(ModulesTree *)value;
- (void)removeModulesTreeObject:(ModulesTree *)value;
- (void)addModulesTree:(NSSet<ModulesTree *> *)values;
- (void)removeModulesTree:(NSSet<ModulesTree *> *)values;

- (void)addVehicleprofilesObject:(Vehicleprofile *)value;
- (void)removeVehicleprofilesObject:(Vehicleprofile *)value;
- (void)addVehicleprofiles:(NSSet<Vehicleprofile *> *)values;
- (void)removeVehicleprofiles:(NSSet<Vehicleprofile *> *)values;

@end

NS_ASSUME_NONNULL_END
