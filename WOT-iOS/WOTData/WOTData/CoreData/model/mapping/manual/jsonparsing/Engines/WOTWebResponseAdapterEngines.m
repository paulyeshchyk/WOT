//
//  WOTWebResponseAdapterEngines.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterEngines.h"
#import <WOTData/WOTData.h>
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterEngines

- (void)parseJSON:(NSDictionary *)json error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankEnginessDictionary = json[WOTApiKeys.data];
    
    NSArray *tankEnginesArray = [tankEnginessDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankEnginesArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankEngineJSON = tankEnginessDictionary[key];
            if (![tankEngineJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.module_id,tankEngineJSON[WOTApiKeys.module_id]];
            Tankengines *tankEngines = (Tankengines *)[Tankengines findOrCreateObjectWithPredicate:predicate context:context];
            [tankEngines mappingFrom:tankEngineJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
