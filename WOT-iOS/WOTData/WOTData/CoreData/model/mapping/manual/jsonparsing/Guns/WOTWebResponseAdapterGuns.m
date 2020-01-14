//
//  WOTWebResponseAdapterGuns.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterGuns.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterGuns

- (void)parseData:(id)data error:(NSError *)error binary:(NSData * _Nullable)binary{

    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankGunsDictionary = [data[WOTApiKeys.data] copy];
    
    NSArray *tankGunsArray = [tankGunsDictionary allKeys];
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankGunsArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankGunsJSON = tankGunsDictionary[key];
            if (![tankGunsJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.module_id,tankGunsJSON[WOTApiKeys.module_id]];
            Tankguns *tankGuns = (Tankguns *)[Tankguns findOrCreateObjectWithPredicate:predicate context:context];
            [tankGuns mappingFrom:tankGunsJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end