//
//  WOTDataProviderTanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTDataProviderTanks.h"
#import "Tanks.h"

@implementation WOTDataProviderTanks

- (void)dealloc {
    
}

- (void)parseData:(id)data {
    
    NSDictionary *tanksDictionary = data[WOT_KEY_DATA];
    
    NSArray *tanksArray = [tanksDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    for (NSString *key in tanksArray) {
        
        NSDictionary *tankJSON = tanksDictionary[key];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID,tankJSON[WOT_KEY_TANK_ID]];
        Tanks *tank = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [tank fillPropertiesFromDictioary:tankJSON];
    }
    
    if ([context hasChanges]) {
        
        NSError *error = nil;
        [context save:&error];
    }
    
    
    
}

- (void)parseError:(NSError *)error {
    
    NSLog(@"%@",error.localizedDescription);
}

@end
