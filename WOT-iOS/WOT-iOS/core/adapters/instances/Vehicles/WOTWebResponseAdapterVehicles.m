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
#import "Tankengines.h"
#import "NSManagedObject+CoreDataOperations.h"
#import "WOTRequestExecutor.h"

@implementation WOTWebResponseAdapterVehicles

- (void)parseData:(id)data error:(NSError *)error {
    
    [self parseData:data queue:nil error:error];
}

- (void)parseData:(id)data queue:(NSOperationQueue *)queue error:(NSError *)error {

    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }


    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    [context performBlock:^{


        
        NSMutableDictionary *requests = [[NSMutableDictionary alloc] init];
        
        NSArray *availableLinks = [Vehicles availableLinks];
        
        
        NSDictionary *objects = data[WOT_KEY_DATA];
        for (id key in [objects allKeys]) {
            
            id jSON = objects[key];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TAG,jSON[WOT_KEY_TAG]];
            Vehicles *vehicle = [Vehicles findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [vehicle fillPropertiesFromDictionary:jSON];
            

    #warning should be refactored
            
            NSPredicate *tanksPredicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID, @([key integerValue])];
            Tanks *tank = [Tanks findOrCreateObjectWithPredicate:tanksPredicate inManagedObjectContext:context];
            [tank setVehicles:vehicle];

            for (WOTWebResponseLink *wotWebResponseLink in availableLinks) {
                
                Class clazz = wotWebResponseLink.clazz;
                if ([clazz isSubclassOfClass:[NSManagedObject class]]) {

                    NSMutableSet *linkedObjects = [[NSMutableSet alloc] init];
                    
                    /*
                     jSonLinks is familiar to 
                         jSonLink =     (
                             3429,
                             3685
                         );
                     */

                    if (wotWebResponseLink.jsonKeyName) {
                        
                        NSArray *jSonLinks = jSON[wotWebResponseLink.jsonKeyName];
                        
                        /*
                         * hasLinkedObjects can be FALSE,
                         * i.e. vehicle has no turrets (ISU-152)
                         */
                        BOOL hasLinkedObjects = ([jSonLinks count] > 0);
                        if (hasLinkedObjects) {
                            
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
            }
        }

        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }

        for(NSNumber *requestId in requests) {
            
            id args = requests[requestId];
            id request = [[WOTRequestExecutor sharedInstance] executeRequestById:[requestId integerValue] args:args inQueue:queue];
            NSLog(@"%@",[request description]);
        }
    
    }];

}

@end
