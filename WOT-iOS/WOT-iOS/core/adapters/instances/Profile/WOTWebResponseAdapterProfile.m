//
//  WOTWebResponseAdapterProfile.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterProfile.h"

#import "Vehicleprofile.h"
#import "VehicleprofileAmmoList.h"
#import "VehicleprofileAmmo.h"
#import "VehicleprofileAmmoDamage.h"
#import "VehicleprofileAmmoPenetration.h"
#import "VehicleprofileEngine.h"
#import "VehicleprofileGun.h"
#import "VehicleprofileTurret.h"
#import "VehicleprofileSuspension.h"
#import "VehicleprofileRadio.h"
#import "VehicleprofileArmor.h"
#import "VehicleprofileArmorList.h"
#import "Tanks.h"


@implementation WOTWebResponseAdapterProfile

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *profileJSON = data[WOT_KEY_DATA];

    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    [context performBlock:^{
        
        [self context:context parseProfile:profileJSON];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

#pragma mark - private
- (NSUInteger)hashForDictionary:(NSDictionary *)dict {
 
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    return [data hash];
}

- (void)context:(NSManagedObjectContext *)context parseProfile:(NSDictionary *)profileJSON {

//engine //suspension //gun //turret //radio
    
    NSArray *keys = [profileJSON allKeys];
    for (id key in keys) {

        NSDictionary *profile = profileJSON[key];
        
        NSUInteger hashName = [self hashForDictionary:profile];
        NSString *hashNameStr = [NSString stringWithFormat:@"%d",hashName];
        NSPredicate *vehicleProfilePredicate = [NSPredicate predicateWithFormat:@"%K == %d",WOT_KEY_HASHNAME,hashName];
        Vehicleprofile *vehicleProfile = [Vehicleprofile findOrCreateObjectWithPredicate:vehicleProfilePredicate inManagedObjectContext:context];
        [vehicleProfile setHashName:[NSDecimalNumber decimalNumberWithString:hashNameStr]];
        [vehicleProfile fillPropertiesFromDictionary:profile];

        id ammo = [self context:context parseAmmo:profile[@"ammo"]];
        [vehicleProfile setAmmo:ammo];

        id engine = [self context:context parseEngine:profile[@"engine"]];
        [vehicleProfile setEngine:engine];

        id suspension = [self context:context parseSuspension:profile[@"suspension"]];
        [vehicleProfile setSuspension:suspension];

        id armor = [self context:context parseArmor:profile[@"armor"]];
        [vehicleProfile setArmor:armor];

        id gun = [self context:context parseGun:profile[@"gun"]];
        [vehicleProfile setGun:gun];

        id turret = [self context:context parseTurret:profile[@"turret"]];
        [vehicleProfile setTurret:turret];

        id radio = [self context:context parseRadio:profile[@"radio"]];
        [vehicleProfile setRadio:radio];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d",WOT_KEY_TANK_ID,[key integerValue]];
        Tanks *tank = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [tank addVehicleprofilesObject:vehicleProfile];
    }
}

- (id)context:(NSManagedObjectContext *)context parseEngine:(NSDictionary *)engine {
    
    VehicleprofileEngine *result = [VehicleprofileEngine insertNewObjectInManagedObjectContext:context];
    [result fillPropertiesFromDictionary:engine];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseSuspension:(NSDictionary *)suspension {

    VehicleprofileSuspension *result = [VehicleprofileSuspension insertNewObjectInManagedObjectContext:context];
    [result fillPropertiesFromDictionary:suspension];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseArmor:(NSDictionary *)armor {
    
    VehicleprofileArmorList *result = [VehicleprofileArmorList insertNewObjectInManagedObjectContext:context];

    id turretArmor = armor[@"turret"];
    VehicleprofileArmor *turret = [VehicleprofileArmor insertNewObjectInManagedObjectContext:context];
    [turret fillPropertiesFromDictionary:turretArmor];
    [result setTurret:turret];

    id hullArmor = armor[@"hull"];
    VehicleprofileArmor *hull = [VehicleprofileArmor insertNewObjectInManagedObjectContext:context];
    [hull fillPropertiesFromDictionary:hullArmor];
    [result setHull:hull];
    
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseGun:(NSDictionary *)gun {
    
    VehicleprofileGun *result = [VehicleprofileGun insertNewObjectInManagedObjectContext:context];
    [result fillPropertiesFromDictionary:gun];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseTurret:(NSDictionary *)turret {
    
    VehicleprofileTurret *result = [VehicleprofileTurret insertNewObjectInManagedObjectContext:context];
    [result fillPropertiesFromDictionary:turret];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseRadio:(NSDictionary *)radio {
    
    VehicleprofileRadio *result = [VehicleprofileRadio insertNewObjectInManagedObjectContext:context];
    [result fillPropertiesFromDictionary:radio];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseAmmo:(NSArray *)ammo {
    
    VehicleprofileAmmoList *result = [VehicleprofileAmmoList insertNewObjectInManagedObjectContext:context];
    
    for(NSDictionary *ammoJSON in ammo) {
        
        VehicleprofileAmmo *ammoObject = [VehicleprofileAmmo insertNewObjectInManagedObjectContext:context];
        [ammoObject fillPropertiesFromDictionary:ammoJSON];
        
        VehicleprofileAmmoPenetration *ammoPenetration = [VehicleprofileAmmoPenetration insertNewObjectInManagedObjectContext:context];
        [ammoPenetration fillPropertiesFromDictionary:ammoJSON[@"penetration"]];
        [ammoObject setPenetration:ammoPenetration];
        
        VehicleprofileAmmoDamage *ammoDamage = [VehicleprofileAmmoDamage insertNewObjectInManagedObjectContext:context];
        [ammoDamage fillPropertiesFromDictionary:ammoJSON[@"damage"]];
        [ammoObject setDamage:ammoDamage];

        [result addVehicleprofileAmmoObject:ammoObject];
    }
    return result;
}

@end
