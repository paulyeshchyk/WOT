//
//  WOTWebResponseAdapterVehicles.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterVehicles.h"
#import "Vehicles.h"
#import "Tankengines.h"
#import "NSManagedObject+CoreDataOperations.h"
#import "WOTRequestExecutor.h"

@implementation WOTWebResponseAdapterVehicles

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }

    NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
    
    NSArray *availableLinks = [Vehicles availableLinks];

    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    
    NSDictionary *objects = data[WOT_KEY_DATA];
    for (id key in [objects allKeys]) {
        
        id jSON = objects[key];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TAG,jSON[WOT_KEY_TAG]];
        Vehicles *vehicle = [Vehicles findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [vehicle fillPropertiesFromDictionary:jSON];

        for (WOTWebResponseLink *wotWebResponseLink in availableLinks) {
            
            Class clazz = wotWebResponseLink.clazz;
            if ([clazz isSubclassOfClass:[NSManagedObject class]]) {

                NSMutableSet *linkedObjects = [[NSMutableSet alloc] init];
                
                NSArray *jSonLinks = jSON[wotWebResponseLink.jsonKeyName];
                for (NSString *jSONLinkId in jSonLinks) {
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",wotWebResponseLink.coredataIdName,jSONLinkId];
                    NSManagedObject *objToLink = [clazz findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
                    [objToLink setValue:jSONLinkId forKey:wotWebResponseLink.coredataIdName];
                    [linkedObjects addObject:objToLink];
                }
                
                NSDictionary *args = [wotWebResponseLink requestArgsForAvailableIds:jSonLinks];
                
                [requests setObject:args forKey:@(wotWebResponseLink.wotWebRequestId)];

                if (wotWebResponseLink.linkItemsBlock) {
                    
                    wotWebResponseLink.linkItemsBlock(vehicle, linkedObjects);
                }
            }
        }
    }

    if ([context hasChanges]) {
        
        NSError *error = nil;
        [context save:&error];
    }
    

    for(NSNumber *requestId in requests) {
    
        id args = requests[requestId];
        [[WOTRequestExecutor sharedInstance] executeRequestById:[requestId integerValue] args:args];
    }
    
    
    
}




@end
