//
//  WOTWebResponseAdapterVehicles.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterVehicles.h"
#import "Vehicles.h"

@implementation WOTWebResponseAdapterVehicles

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    
    NSDictionary *objects = data[WOT_KEY_DATA];
    for (id key in [objects allKeys]) {
        
        id jSON = objects[key];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TAG,jSON[WOT_KEY_TAG]];
        Vehicles *vehicle = [Vehicles findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
//        [vehicle fillPropertiesFromDictioary:jSON];
    }

    if ([context hasChanges]) {
        
        NSError *error = nil;
        [context save:&error];
    }
}


@end
