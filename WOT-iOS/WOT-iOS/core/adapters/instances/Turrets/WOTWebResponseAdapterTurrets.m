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
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankTurretsDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankTurretsArray = [tankTurretsDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankTurretsArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankTurretsJSON = tankTurretsDictionary[key];
            if (![tankTurretsJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankTurretsJSON[WOT_KEY_MODULE_ID]];
            Tankturrets *tankturrets = [Tankturrets findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tankturrets fillPropertiesFromDictionary:tankTurretsJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}


@end
