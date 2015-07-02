//
//  WOTWebResponseAdapterTurrets.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterTurrets.h"
#import "Tankturrets.h"

@implementation WOTWebResponseAdapterTurrets

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankTurretsDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankTurretsArray = [tankTurretsDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    [context performBlock:^{
        
        for (NSString *key in tankTurretsArray) {
            
            NSDictionary *tankTurretsJSON = tankTurretsDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankTurretsJSON[WOT_KEY_MODULE_ID]];
            Tankturrets *tankturrets = [Tankturrets findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tankturrets fillPropertiesFromDictionary:tankTurretsJSON];
        }
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}


@end
