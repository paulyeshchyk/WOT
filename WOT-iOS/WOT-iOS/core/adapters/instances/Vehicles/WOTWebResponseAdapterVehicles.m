//
//  WOTWebResponseAdapterVehicles.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterVehicles.h"
#import "Tanks.h"
#import "Vehicles.h"
#import "Tankchassis.h"
#import "Tankguns.h"
#import "Tankradios.h"
#import "Tankturrets.h"
#import "Tankengines.h"
#import "ModulesTree.h"
#import "NSManagedObject+CoreDataOperations.h"
#import "WOTRequestExecutor.h"

@implementation WOTWebResponseAdapterVehicles


- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    [context performBlock:^{
        
        NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
        
        NSDictionary *objects = data[WOT_KEY_DATA];
        for (id key in [objects allKeys]) {
            
            id jSON = objects[key];
            NSDictionary *requestsForSingleObj = [self parseVehicleObject:jSON class:[Vehicles class] context:context key:key];
            [requests addEntriesFromDictionary:requestsForSingleObj];
            
        }
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
        
        [requests enumerateKeysAndObjectsUsingBlock:^(NSNumber *requestId, id obj, BOOL *stop) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id args = requests[requestId];
                WOTRequest *request = [[WOTRequestExecutor sharedInstance] requestById:[requestId integerValue]];
                [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
                
#warning check groupId
                [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:@"Vehicle"];
                
            });
        }];
        
    }];
}

#pragma mark - private
- (NSMutableDictionary *)parseVehicleObject:(NSDictionary *)jSON class:(Class)clazz context:(NSManagedObjectContext *)context key:(id)key{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TAG,jSON[WOT_KEY_TAG]];
    Vehicles *vehicle = [Vehicles findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
    [vehicle fillPropertiesFromDictionary:jSON];
    
    
#warning should be refactored
    
    NSPredicate *tanksPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID, @([key integerValue])];
    Tanks *tank = [Tanks findOrCreateObjectWithPredicate:tanksPredicate inManagedObjectContext:context];
    [tank setVehicles:vehicle];
    
    NSArray *availableLinks = [clazz availableLinks];

    for (WOTWebResponseLink *wotWebResponseLink in availableLinks) {
        
        Class clazz = wotWebResponseLink.clazz;
        if (![clazz isSubclassOfClass:[NSManagedObject class]]) {
            
            return result;
        }
        
        if (!wotWebResponseLink.jsonKeyName) {
            
            return result;
        }
        
        id jSonLinks = jSON[wotWebResponseLink.jsonKeyName];
        if ([jSonLinks isKindOfClass:[NSArray class]]) {
            
            NSDictionary *requestsForLinks  = [self parseArrayLinkIDs:jSonLinks
                                                   wotWebResponseLink:wotWebResponseLink
                                                              context:context
                                                              vehicle:vehicle];
            [result addEntriesFromDictionary:requestsForLinks];
            
        } else if([jSonLinks isKindOfClass:[NSDictionary class]]) {
            
#warning to be implemented
            NSDictionary *requestsForObjs = [self parseDictionaryLink:jSonLinks
                                                   wotWebResponseLink:wotWebResponseLink
                                                              context:context
                                                              vehicle:vehicle];
            [result addEntriesFromDictionary:requestsForObjs];
            
            
        } else {
            
        }
    }
    
    return result;
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
    BOOL hasLinkedObjects = ([arrayLinkIDs count] > 0);
    if (!hasLinkedObjects) {
        
        return requests;
    }

    Class clazz = wotWebResponseLink.clazz;
    NSMutableSet *linkedObjects = [[NSMutableSet alloc] init];
    [arrayLinkIDs enumerateObjectsUsingBlock:^(NSNumber *jSONLinkId, NSUInteger idx, BOOL *stop) {
        
        //assuming that jSONLinkId is allways NSNumber
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",wotWebResponseLink.coredataIdName,jSONLinkId];
        NSManagedObject *objToLink = [clazz findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
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


- (NSDictionary *)parseDictionaryLink:(NSDictionary *)dictionaryLink wotWebResponseLink:(WOTWebResponseLink *)wotWebResponseLink context:(NSManagedObjectContext *)context vehicle:(Vehicles *)vehicle{
    
    NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
    
    NSArray *keys = [dictionaryLink allKeys];
    BOOL hasLinkedObjects = ([keys count] > 0);
    if (!hasLinkedObjects) {
        
        return requests;
    }
    
    Class clazz = wotWebResponseLink.clazz;
    [self parseModulesJSON:dictionaryLink clazz:clazz keys:keys coreDataIdName:wotWebResponseLink.coredataIdName context:context vehicle:vehicle];
    
    return requests;
}


- (void)parseModulesJSON:(NSDictionary *)json clazz:(Class)clazz keys:(NSArray *)keys coreDataIdName:(id)coreDataIdName context:(NSManagedObjectContext *)context vehicle:(Vehicles *)vehicle{
    
    if (!(([keys isKindOfClass:[NSArray class]]) && ([keys count] > 0))) {

        return;
    }
    
    NSMutableArray *allModuleIDs = [[NSMutableArray alloc] init];
    
    [keys enumerateObjectsUsingBlock:^(id moduleId, NSUInteger idx, BOOL *stop) {
        
        ModulesTree *returningModule = nil;
        NSString *key = [moduleId isKindOfClass:[NSNumber class]]?[moduleId stringValue]:moduleId;
        NSDictionary *data = json[key];
        NSArray *childModuleIDs = [self parentModule:nil addChildModuleFromJSON:data coreDataIdName:coreDataIdName jSONLinkId:@([key integerValue]) clazz:clazz context:context  vehicle:vehicle returningModule:&returningModule];
        if (([childModuleIDs isKindOfClass:[NSArray class]]) && ([childModuleIDs count] != 0)) {
            
            [allModuleIDs addObjectsFromArray:childModuleIDs];
        }
        
        
        [vehicle addModulesTreeObject:returningModule];
    }];
    
    NSMutableArray *nextChildren = [[NSMutableArray alloc] init];
    [allModuleIDs enumerateObjectsUsingBlock:^(NSNumber *moduleID, NSUInteger idx, BOOL *stop) {
        
        ModulesTree *returningModule = nil;
        NSDictionary *data = json[[moduleID stringValue]];
        NSArray *nextChild = [self parentModule:nil addChildModuleFromJSON:data coreDataIdName:coreDataIdName jSONLinkId:moduleID clazz:clazz context:context vehicle:vehicle returningModule:&returningModule];
        if (([nextChild isKindOfClass:[NSArray class]]) && ([nextChild count] != 0)) {
            
            [nextChildren addObjectsFromArray:nextChild];
        }
    }];
    
    [self parseModulesJSON:json clazz:clazz keys:nextChildren coreDataIdName:coreDataIdName context:context vehicle:vehicle];
}


- (NSArray *)parentModule:(ModulesTree *)parentModule addChildModuleFromJSON:(NSDictionary *)data coreDataIdName:(NSString *)coreDataIdName jSONLinkId:(id)jSONLinkId clazz:(Class)clazz context:(NSManagedObjectContext *)context vehicle:(Vehicles *)vehicle returningModule:(ModulesTree **)returningModule{
    
    debugLog(@"%@",data);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",coreDataIdName,jSONLinkId];
    ModulesTree *objToLink = [clazz findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
    [objToLink setValue:jSONLinkId forKey:coreDataIdName];
    [objToLink fillPropertiesFromDictionary:data];
    
    *returningModule = objToLink;
    
    
    NSString *type = data[WOT_KEY_TYPE];
    if ([type isEqualToString:WOT_VALUE_VEHICLE_CHASSIS]) {
        
        Tankchassis *chassis = [Tankchassis findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [parentModule addNextChassisObject:chassis];
    }
    if ([type isEqualToString:WOT_VALUE_VEHICLE_GUN]) {
        
        Tankguns *gun = [Tankguns findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [parentModule addNextGunsObject:gun];
    }
    if ([type isEqualToString:WOT_VALUE_VEHICLE_ENGINE]) {
        
        Tankengines *engine = [Tankengines findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [parentModule addNextEnginesObject:engine];
    };
    if ([type isEqualToString:WOT_VALUE_VEHICLE_TURRET]) {
        
        Tankturrets *turrets = [Tankturrets findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [parentModule addNextTurretsObject:turrets];
    };
    if ([type isEqualToString:WOT_VALUE_VEHICLE_RADIO]) {
        
        
        Tankradios *radios = [Tankradios findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [parentModule addNextRadiosObject:radios];
    };

//    [vehicle addRadiosObject:objToLink];
    
    return data[WOT_KEY_NEXT_MODULES];
}

@end
