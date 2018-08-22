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

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tanksDictionary = data[WOT_KEY_DATA];
    
    NSArray *tanksArray = [tanksDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];

    [context performBlock:^{
        
        [tanksArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankJSON = tanksDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID,tankJSON[WOT_KEY_TANK_ID]];
            Tanks *tank = [Tanks findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tank fillPropertiesFromDictionary:tankJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
