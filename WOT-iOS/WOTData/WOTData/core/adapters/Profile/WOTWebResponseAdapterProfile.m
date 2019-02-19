//
//  WOTWebResponseAdapterProfile.m
//  WOT-iOS
//
//  Created on 9/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterProfile.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import "NSManagedObject+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterProfile

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *profileJSON = data[WOTApiKeys.data];

    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [self context:context parseProfile:profileJSON];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

#pragma mark - private

- (void)context:(NSManagedObjectContext *)context parseProfile:(NSDictionary *)profileJSON {

//engine //suspension //gun //turret //radio
    
    NSArray *keys = [profileJSON allKeys];
    for (id key in keys) {

        NSDictionary *profile = profileJSON[key];
        
        NSUInteger hashName = profile.completeHash;
        
        NSString *hashNameStr = [NSString stringWithFormat:@"%lu",(unsigned long)hashName];
        NSPredicate *vehicleProfilePredicate = [NSPredicate predicateWithFormat:@"%K == %d",WOT_KEY_HASHNAME,hashName];
        Vehicleprofile *vehicleProfile = (Vehicleprofile *)[Vehicleprofile findOrCreateObjectWithPredicate:vehicleProfilePredicate context:context];
        NSCAssert(vehicleProfile, @"vehicleProfile should not be nil");
        
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d",WOTApiKeys.tank_id,[key integerValue]];
        Tanks *tank = (Tanks *)[Tanks findOrCreateObjectWithPredicate:predicate context:context];
        [tank addVehicleprofilesObject:vehicleProfile];
    }
}

- (id)context:(NSManagedObjectContext *)context parseEngine:(NSDictionary *)engine {
    
    VehicleprofileEngine *result = (VehicleprofileEngine *)[VehicleprofileEngine insertNewObject:context];
    [result fillPropertiesFromDictionary:engine];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseSuspension:(NSDictionary *)suspension {

    VehicleprofileSuspension *result = (VehicleprofileSuspension *)[VehicleprofileSuspension insertNewObject:context];
    [result fillPropertiesFromDictionary:suspension];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseArmor:(NSDictionary *)armor {
    
    VehicleprofileArmorList *result = (VehicleprofileArmorList *)[VehicleprofileArmorList insertNewObject:context];

    id turretArmor = armor[@"turret"];
    VehicleprofileArmor *turret = (VehicleprofileArmor *)[VehicleprofileArmor insertNewObject:context];
    [turret fillPropertiesFromDictionary:turretArmor];
    [result setTurret:turret];

    id hullArmor = armor[@"hull"];
    VehicleprofileArmor *hull = (VehicleprofileArmor *)[VehicleprofileArmor insertNewObject:context];
    [hull fillPropertiesFromDictionary:hullArmor];
    [result setHull:hull];
    
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseGun:(NSDictionary *)gun {
    
    VehicleprofileGun *result = (VehicleprofileGun *)[VehicleprofileGun insertNewObject:context];
    [result fillPropertiesFromDictionary:gun];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseTurret:(NSDictionary *)turret {
    
    VehicleprofileTurret *result = (VehicleprofileTurret *)[VehicleprofileTurret insertNewObject:context];
    [result fillPropertiesFromDictionary:turret];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseRadio:(NSDictionary *)radio {
    
    VehicleprofileRadio *result = (VehicleprofileRadio *)[VehicleprofileRadio insertNewObject:context];
    [result fillPropertiesFromDictionary:radio];
    return result;
}

- (id)context:(NSManagedObjectContext *)context parseAmmo:(NSArray *)ammo {
    
    VehicleprofileAmmoList *result = (VehicleprofileAmmoList *)[VehicleprofileAmmoList insertNewObject:context];
    
    for(NSDictionary *ammoJSON in ammo) {
        
        VehicleprofileAmmo *ammoObject = (VehicleprofileAmmo *)[VehicleprofileAmmo insertNewObject:context];
        [ammoObject fillPropertiesFromDictionary:ammoJSON];
        
        VehicleprofileAmmoPenetration *ammoPenetration = (VehicleprofileAmmoPenetration *)[VehicleprofileAmmoPenetration insertNewObject:context];
        [ammoPenetration fillPropertiesFromDictionary:ammoJSON[@"penetration"]];
        [ammoObject setPenetration:ammoPenetration];
        
        VehicleprofileAmmoDamage *ammoDamage = (VehicleprofileAmmoDamage *)[VehicleprofileAmmoDamage insertNewObject:context];
        [ammoDamage fillPropertiesFromDictionary:ammoJSON[@"damage"]];
        [ammoObject setDamage:ammoDamage];

        [result addVehicleprofileAmmoObject:ammoObject];
    }
    return result;
}

@end
