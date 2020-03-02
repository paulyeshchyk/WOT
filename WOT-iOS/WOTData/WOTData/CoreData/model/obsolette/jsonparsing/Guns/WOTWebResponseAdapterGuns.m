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

- (void)parseJSON:(NSDictionary * __nonnull)json nestedRequestsCallback:(void (^ _Nullable)(NSArray<JSONMappingNestedRequest *> * _Nullable))nestedRequestsCallback {

    NSDictionary *tankGunsDictionary = json[WGJsonFields.data];
    
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
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WGJsonFields.module_id,tankGunsJSON[WGJsonFields.module_id]];
            Tankguns *tankGuns = (Tankguns *)[Tankguns findOrCreateObjectWithPredicate:predicate context:context];
            [tankGuns mappingFromJSON:tankGunsJSON into: context completion:^(NSArray<JSONMappingNestedRequest *> * _Nullable requests) {
                
            }];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
