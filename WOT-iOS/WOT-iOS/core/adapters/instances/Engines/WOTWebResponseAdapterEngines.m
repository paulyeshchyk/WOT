//
//  WOTWebResponseAdapterEngines.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/18/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterEngines.h"
#import "Tankengines.h"

@implementation WOTWebResponseAdapterEngines

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankEnginessDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankEnginesArray = [tankEnginessDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankEnginesArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankEngineJSON = tankEnginessDictionary[key];
            if (![tankEngineJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankEngineJSON[WOT_KEY_MODULE_ID]];
            Tankengines *tankEngines = [Tankengines findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tankEngines fillPropertiesFromDictionary:tankEngineJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
