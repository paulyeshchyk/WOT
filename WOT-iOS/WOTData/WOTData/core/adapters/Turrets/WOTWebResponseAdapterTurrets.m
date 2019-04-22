//
//  WOTWebResponseAdapterTurrets.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterTurrets.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTPivot/WOTPivot-Swift.h>
#import "NSManagedObject+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterTurrets

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankTurretsDictionary = data[WOTApiKeys.data];
    
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
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", WOTApiKeys.module_id, tankTurretsJSON[WOTApiKeys.module_id]];
            Tankturrets *tankturrets = (Tankturrets *)[Tankturrets findOrCreateObjectWithPredicate:predicate context:context];
            [tankturrets mappingFrom:tankTurretsJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}


@end
