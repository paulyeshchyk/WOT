//
//  WOTWebResponseAdapterTanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterTanks.h"
#import "Tanks.h"

@implementation WOTWebResponseAdapterTanks

- (void)parseData:(id)data queue:(NSOperationQueue *)queue error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tanksDictionary = data[WOT_KEY_DATA];
    
    NSArray *tanksArray = [tanksDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    for (NSString *key in tanksArray) {
        
        NSDictionary *tankJSON = tanksDictionary[key];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID,tankJSON[WOT_KEY_TANK_ID]];
        Tanks *tank = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [tank fillPropertiesFromDictionary:tankJSON];
    }
    
    if ([context hasChanges]) {
        
        NSError *error = nil;
        [context save:&error];
    }
}

- (void)parseData:(id)data error:(NSError *)error {

    [self parseData:data queue:nil error:error];
}

@end
