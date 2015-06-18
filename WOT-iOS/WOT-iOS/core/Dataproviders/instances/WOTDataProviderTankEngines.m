//
//  WOTDataProviderTankEngines.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTDataProviderTankEngines.h"
#import "Tankengines.h"

@implementation WOTDataProviderTankEngines

- (void)dealloc {
    
}

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankEnginessDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankEnginesArray = [tankEnginessDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    for (NSString *key in tankEnginesArray) {
        
        NSDictionary *tankEngineJSON = tankEnginessDictionary[key];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankEngineJSON[WOT_KEY_MODULE_ID]];
        Tankengines *tankEngines = [Tankengines findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [tankEngines fillPropertiesFromDictioary:tankEngineJSON];
    }
    
    if ([context hasChanges]) {
        
        NSError *error = nil;
        [context save:&error];
    }
}

@end
