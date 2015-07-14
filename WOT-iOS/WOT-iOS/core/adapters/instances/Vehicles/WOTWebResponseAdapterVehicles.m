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
#import "WOTWebResponseAdapterModulesTree.h"

@implementation WOTWebResponseAdapterVehicles


- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
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
        
        id jSONLink = jSON[wotWebResponseLink.jsonKeyName];
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
                                                                 tank:tank];
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
    BOOL hasLinkedObjects = ([NSArray hasDataInArray:arrayLinkIDs]);
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


- (NSDictionary *)parseDictionaryLink:(NSDictionary *)jSON wotWebResponseLink:(WOTWebResponseLink *)wotWebResponseLink context:(NSManagedObjectContext *)context tank:(Tanks *)tank{
    
    NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
    
    NSArray *keys = [jSON allKeys];
    BOOL hasLinkedObjects = ([NSArray hasDataInArray:keys]);
    if (!hasLinkedObjects) {
        
        return requests;
    }
    
    Class clazz = wotWebResponseLink.clazz;
    [self parseModulesJSON:jSON clazz:clazz keys:keys coreDataIdName:wotWebResponseLink.coredataIdName context:context tank:tank];
    
    return requests;
}


- (void)parseModulesJSON:(NSDictionary *)jSON clazz:(Class)clazz keys:(NSArray *)keys coreDataIdName:(id)coreDataIdName context:(NSManagedObjectContext *)context tank:(Tanks *)tank{
    
    if (![NSArray hasDataInArray:keys]) {

        return;
    }
    
    NSMutableDictionary *childrenModuleIDs = [[NSMutableDictionary alloc] init];
    [keys enumerateObjectsUsingBlock:^(id moduleId, NSUInteger idx, BOOL *stop) {
        
        ModulesTree *returningModule = nil;
        NSString *key = [moduleId isKindOfClass:[NSNumber class]]?[moduleId stringValue]:moduleId;
        NSDictionary *data = jSON[key];
        NSArray *nextModuleIDs = [self parentModule:nil addChildModuleFromJSON:data coreDataIdName:coreDataIdName jSONLinkId:@([key integerValue]) clazz:clazz context:context returningModule:&returningModule];
        if ([NSArray hasDataInArray:nextModuleIDs]) {
            
            NSArray *new = nil;
            NSArray *old = childrenModuleIDs[key];
            if ([NSArray hasDataInArray:old]){
                
                new = [NSArray arrayWithArray:old];
            } else {
                
                if ([NSArray hasDataInArray:nextModuleIDs]) {
                    
                    new = [NSArray arrayWithArray:nextModuleIDs];
                }
            }
            
            [childrenModuleIDs setObject:new forKey:key];
        }

        [tank addModulesTreeObject:returningModule];
    }];
    
    NSMutableArray *nextChildren = [[NSMutableArray alloc] init];
    [[childrenModuleIDs allKeys] enumerateObjectsUsingBlock:^(NSString *parentKey, NSUInteger idx, BOOL *stop) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",coreDataIdName,@([parentKey integerValue])];
        ModulesTree *parent = [clazz findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        
        NSArray *children = childrenModuleIDs[parentKey];
        [children enumerateObjectsUsingBlock:^(NSNumber *moduleID, NSUInteger idx, BOOL *stop) {
            
            ModulesTree *returningModule = nil;
            NSDictionary *data = jSON[[moduleID stringValue]];
            NSArray *nextChild = [self parentModule:parent addChildModuleFromJSON:data coreDataIdName:coreDataIdName jSONLinkId:moduleID clazz:clazz context:context returningModule:&returningModule];
            if ([NSArray hasDataInArray:nextChild]) {
                
                [nextChildren addObjectsFromArray:nextChild];
            }
        }];
    }];
    
    [self parseModulesJSON:jSON clazz:clazz keys:nextChildren coreDataIdName:coreDataIdName context:context tank:tank];
}


- (NSArray *)parentModule:(ModulesTree *)parentModule addChildModuleFromJSON:(NSDictionary *)jSON coreDataIdName:(NSString *)coreDataIdName jSONLinkId:(id)jSONLinkId clazz:(Class)clazz context:(NSManagedObjectContext *)context returningModule:(ModulesTree **)returningModule{
    
    [context performBlockAndWait:^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",coreDataIdName,jSONLinkId];
        ModulesTree *moduleTree = [clazz findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [moduleTree setValue:jSONLinkId forKey:coreDataIdName];
        [moduleTree fillPropertiesFromDictionary:jSON];
        
        *returningModule = moduleTree;
        
        
        NSArray *nextTanks = jSON[WOT_KEY_NEXT_TANKS];
        if ([NSArray hasDataInArray:nextTanks]) {
            
            [nextTanks enumerateObjectsUsingBlock:^(NSString *nextTankId, NSUInteger idx, BOOL *stop) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID,nextTankId];
                Tanks *tanks = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
                [moduleTree addNextTanksObject:tanks];
            }];
        }
        
        
        NSString *type = jSON[WOT_KEY_TYPE];
        if ([type isEqualToString:WOT_VALUE_VEHICLE_CHASSIS]) {
            
            Tankchassis *chassis = [Tankchassis findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [moduleTree addNextChassisObject:chassis];
        }
        if ([type isEqualToString:WOT_VALUE_VEHICLE_GUN]) {
            
            Tankguns *gun = [Tankguns findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [moduleTree addNextGunsObject:gun];
        }
        if ([type isEqualToString:WOT_VALUE_VEHICLE_ENGINE]) {
            
            Tankengines *engine = [Tankengines findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [moduleTree addNextEnginesObject:engine];
        };
        if ([type isEqualToString:WOT_VALUE_VEHICLE_TURRET]) {
            
            Tankturrets *turrets = [Tankturrets findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [moduleTree addNextTurretsObject:turrets];
        };
        if ([type isEqualToString:WOT_VALUE_VEHICLE_RADIO]) {
            
            
            Tankradios *radios = [Tankradios findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [moduleTree addNextRadiosObject:radios];
        };

        if (parentModule) {
            
            [parentModule addNextModulesObject:moduleTree];
        }
        
    }];
    return jSON[WOT_KEY_NEXT_MODULES];
}

@end
