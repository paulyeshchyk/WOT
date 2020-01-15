//
//  WOTWebResponseAdapterVehicles.m
//  WOT-iOS
//
//  Created on 6/19/15.
//  Copyright (c) 2015. All rights reserved.
//
#import "WOTWebResponseAdapterVehicles.h"
#import "WOTWebResponseAdapterModulesTree.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterVehicles

#define WOT_REQUEST_ID_VEHICLE_ADOPT @"WOT_REQUEST_ID_VEHICLE_ADOPT"

- (void)parse:(id)data binary:(NSData * _Nullable)binary {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
        
        NSDictionary *objects = data[WOTApiKeys.data];
        for (id key in [objects allKeys]) {
            
            id jSON = objects[key];
            if ([jSON isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *requestsForSingleObj = [self parseVehicleObject:jSON class:[Vehicles class] context:context key:key];
                [requests addEntriesFromDictionary:requestsForSingleObj];
            } else {
                
                debugError(@"json is not valid; jSON class is %@",NSStringFromClass([jSON class]));
            }
        }
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
        
        [requests enumerateKeysAndObjectsUsingBlock:^(NSNumber *requestId, id obj, BOOL *stop) {
            
            [NSThread executeOnMainThread:^{
                
                WOTRequestArguments *args = [[WOTRequestArguments alloc] init:requests[requestId]];
                WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:[requestId integerValue]];
                
                NSString *groupId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_ADOPT,requestId];
                BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:groupId];
                if (canAdd) {
                    
                    [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
                }
            }];
            
        }];
        
    }];
}

- (void)parseData:(id)data error:(NSError *)error binary:(NSData * _Nullable)binary {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    [WebLayerDecoder decodeVehiclesWithBinary: binary];
    
    [self parse:data binary:binary];
}

#pragma mark - private
- (NSDictionary *)parseVehicleObject:(NSDictionary *)jSON class:(Class)clazz context:(NSManagedObjectContext *)context key:(id)key{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.tag,jSON[WOTApiKeys.tag]];
    Vehicles *vehicle = (Vehicles *)[Vehicles findOrCreateObjectWithPredicate:predicate context:context];
    [vehicle mappingFrom:jSON];
    
#warning dirty code
    Vehicleprofile *defaultProfile = (Vehicleprofile *)[Vehicleprofile insertNewObject:context];
    [defaultProfile mappingFrom:jSON[WOTApiKeys.default_profile]];
    vehicle.default_profile = defaultProfile;


#warning should be refactored
    
//    NSPredicate *tanksPredicate = [NSPredicate predicateWithFormat:@"%K == %d",WOTApiKeys.tank_id, [key integerValue]];
//    Vehicles *tank = (Vehicles *)[Vehicles findOrCreateObjectWithPredicate:tanksPredicate context:context];
////    [tank setVehicles:vehicle];
//
    NSArray *availableLinks = [clazz availableLinks];

    for (WOTWebResponseLink *wotWebResponseLink in availableLinks) {

        Class clazz = wotWebResponseLink.clazz;
        if (![clazz isSubclassOfClass:[NSManagedObject class]]) {

            return result;
        }

        if (!wotWebResponseLink.jsonKeyName) {

            return result;
        }

        NSString *linkName = NSLocalizedString(wotWebResponseLink.jsonKeyName, nil);
        id jSONLink = jSON[linkName];
        if ([jSONLink isKindOfClass:[NSArray class]]) {

            NSDictionary *requestsForLinks  = [self parseArrayLinkIDs:jSONLink
                                                   wotWebResponseLink:wotWebResponseLink
                                                              context:context
                                                              vehicle:vehicle];
            [result addEntriesFromDictionary:requestsForLinks];

        } else if([jSONLink isKindOfClass:[NSDictionary class]]) {

            NSDictionary *requestsForObjs = [self parseDictionaryLink:jSONLink
                                                   wotWebResponseLink:wotWebResponseLink
                                                              context:context
                                                              vehicle:vehicle];
            [result addEntriesFromDictionary:requestsForObjs];
        } else {

        }
    }

    return [result copy];
}

/**
 description:
 jSonLinks is familiar to
 jSonLink =     (
 3429,
 3685
 );
 */

- (NSDictionary *)parseArrayLinkIDs:(NSArray *)arrayLinkIDs  wotWebResponseLink:(WOTWebResponseLink *)wotWebResponseLink context:(NSManagedObjectContext *)context vehicle:(Vehicles *)vehicle{

    NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
    
    /*
     * hasLinkedObjects can be FALSE,
     * i.e. vehicle has no turrets (ISU-152)
     */
    if (!arrayLinkIDs.hasItems) {
        
        return requests;
    }

    Class clazz = wotWebResponseLink.clazz;
    NSMutableSet *linkedObjects = [[NSMutableSet alloc] init];
    [arrayLinkIDs enumerateObjectsUsingBlock:^(NSNumber *jSONLinkId, NSUInteger idx, BOOL *stop) {
        
        //assuming that jSONLinkId is allways NSNumber
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",wotWebResponseLink.coredataIdName,jSONLinkId];
        NSManagedObject *objToLink = [clazz findOrCreateObjectWithPredicate:predicate context:context];
        [objToLink setValue:jSONLinkId forKey:wotWebResponseLink.coredataIdName];
        [linkedObjects addObject:objToLink];
    }];
    
    NSDictionary *args = [wotWebResponseLink requestArgsForAvailableIds:arrayLinkIDs];
    [requests setObject:args forKey:@(wotWebResponseLink.wotWebRequestId)];
    if (wotWebResponseLink.linkItemsBlock) {
        
        wotWebResponseLink.linkItemsBlock(vehicle, linkedObjects,nil);
    }
    
    return requests;
}

#pragma mark - modules

- (NSDictionary *)parseDictionaryLink:(NSDictionary *)jSON wotWebResponseLink:(WOTWebResponseLink *)wotWebResponseLink context:(NSManagedObjectContext *)context vehicle:(Vehicles *)tank{
    
    NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
    
    NSArray *keys = [jSON allKeys];
    if (!keys.hasItems) {
        
        return requests;
    }
    
    Class clazz = wotWebResponseLink.clazz;
    [self parseModulesJSON:jSON clazz:clazz keys:keys coreDataIdName:wotWebResponseLink.coredataIdName context:context vehicle:tank];
    
    return requests;
}

- (void)parseModulesJSON:(NSDictionary *)jSON clazz:(Class)clazz keys:(NSArray *)keys coreDataIdName:(id)coreDataIdName context:(NSManagedObjectContext *)context vehicle:(Vehicles *)tank{
    
    if (!keys.hasItems) {

        return;
    }
    
    NSMutableDictionary *childrenModuleIDs = [[NSMutableDictionary alloc] init];
    [keys enumerateObjectsUsingBlock:^(id moduleId, NSUInteger idx, BOOL *stop) {
        
        ModulesTree *returningModule = nil;
        NSString *key = [moduleId isKindOfClass:[NSNumber class]]?[moduleId stringValue]:moduleId;
        NSDictionary *data = jSON[key];
        NSArray *nextModuleIDs = [self parentModule:nil addChildModuleFromJSON:data coreDataIdName:coreDataIdName jSONLinkId:@([key integerValue]) clazz:clazz context:context returningModule:&returningModule];
        if (nextModuleIDs.hasItems) {
            
            NSArray *new = nil;
            NSArray *old = childrenModuleIDs[key];
            if (old.hasItems){
                
                new = [NSArray arrayWithArray:old];
            } else {
                
                if (nextModuleIDs.hasItems) {
                    
                    new = [NSArray arrayWithArray:nextModuleIDs];
                }
            }
            
            [childrenModuleIDs setObject:new forKey:key];
        }

        [tank addModules_treeObject:returningModule];
    }];
    
    NSMutableArray *nextChildren = [[NSMutableArray alloc] init];
    [[childrenModuleIDs allKeys] enumerateObjectsUsingBlock:^(NSString *parentKey, NSUInteger idx, BOOL *stop) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",coreDataIdName,@([parentKey integerValue])];
        ModulesTree *parent = (ModulesTree *)[clazz findOrCreateObjectWithPredicate:predicate context:context];
        
        NSArray *children = childrenModuleIDs[parentKey];
        [children enumerateObjectsUsingBlock:^(NSNumber *moduleID, NSUInteger idx, BOOL *stop) {
            
            ModulesTree *returningModule = nil;
            NSDictionary *data = jSON[[moduleID stringValue]];
            NSArray *nextChild = [self parentModule:parent addChildModuleFromJSON:data coreDataIdName:coreDataIdName jSONLinkId:moduleID clazz:clazz context:context returningModule:&returningModule];
            if (nextChild.hasItems) {
                
                [nextChildren addObjectsFromArray:nextChild];
            }
        }];
    }];
    
    [self parseModulesJSON:jSON clazz:clazz keys:nextChildren coreDataIdName:coreDataIdName context:context vehicle:tank];
}

- (NSArray *)parentModule:(ModulesTree *)parentModule addChildModuleFromJSON:(NSDictionary *)jSON coreDataIdName:(NSString *)coreDataIdName jSONLinkId:(id)jSONLinkId clazz:(Class)clazz context:(NSManagedObjectContext *)context returningModule:(ModulesTree * __autoreleasing *)returningModule{
    
    [context performBlockAndWait:^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",coreDataIdName,jSONLinkId];
        ModulesTree *moduleTree = (ModulesTree *)[clazz findOrCreateObjectWithPredicate:predicate context:context];
        [moduleTree setValue:jSONLinkId forKey:coreDataIdName];
        [moduleTree mappingFrom:jSON];
        
        *returningModule = moduleTree;

//        NSArray *nextTanks = jSON[WOT_KEY_NEXT_TANKS];
//        if (nextTanks.hasItems) {
//            
//            [nextTanks enumerateObjectsUsingBlock:^(NSString *nextTankId, NSUInteger idx, BOOL *stop) {
//                
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.tank_id,nextTankId];
//                Tanks *tanks = (Tanks *)[Tanks findOrCreateObjectWithPredicate:predicate context:context];
//                [moduleTree addNextTanksObject:tanks];
//            }];
//        }

        WOTVehicleModuleType moduleType = [WOTVehicleModuleTypeeOBJcConverter fromString:jSON[WOTApiKeys.type]];
        switch (moduleType) {
            case WOTVehicleModuleTypeChassis: {

                Tankchassis *chassis = (Tankchassis *)[Tankchassis findOrCreateObjectWithPredicate:predicate context:context];
                [moduleTree addNextChassisObject:chassis];
                break;
            }
            case WOTVehicleModuleTypeEngine: {
                
                Tankengines *engine = (Tankengines *)[Tankengines findOrCreateObjectWithPredicate:predicate context:context];
                [moduleTree addNextEnginesObject:engine];
                break;
            }
            case WOTVehicleModuleTypeGun: {

                Tankguns *gun = (Tankguns *)[Tankguns findOrCreateObjectWithPredicate:predicate context:context];
                [moduleTree addNextGunsObject:gun];
                break;
            }
            case WOTVehicleModuleTypeTurret: {
                
                Tankturrets *turrets = (Tankturrets *)[Tankturrets findOrCreateObjectWithPredicate:predicate context:context];
                [moduleTree addNextTurretsObject:turrets];
                break;
            }
            case WOTVehicleModuleTypeRadio: {

                Tankradios *radios = (Tankradios *)[Tankradios findOrCreateObjectWithPredicate:predicate context:context];
                [moduleTree addNextRadiosObject:radios];
                break;
            }
            default: {
                break;
            }
        }
        
        if (parentModule) {
            
            [parentModule addNextModulesObject:moduleTree];
        }
        
    }];
    return jSON[WOTApiKeys.next_modules];
}

@end
