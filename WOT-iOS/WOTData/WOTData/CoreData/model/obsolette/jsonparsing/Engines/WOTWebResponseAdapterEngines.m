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

- (NSError *)parseData:(NSData *)data error:(NSError *) error nestedRequestsCallback:(void (^)(NSArray<JSONMappingNestedRequest *> * _Nullable))nestedRequestsCallback {
    
    return [data parseAsJSON:^(NSDictionary * _Nullable json) {

        NSArray *tankEnginesArray = [json allKeys];
        id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
        NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
        [context performBlock:^{
            
            [tankEnginesArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *tankEngineJSON = json[key];
                if (![tankEngineJSON isKindOfClass:[NSDictionary class]]) {
                    
                    debugError(@"error while parsing");
                    return;
                }

                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WGJsonFields.module_id,tankEngineJSON[WGJsonFields.module_id]];
                Tankengines *tankEngines = (Tankengines *)[Tankengines findOrCreateObjectWithPredicate:predicate context:context];
                [tankEngines mappingFromJSON: tankEngineJSON into: context completion:nestedRequestsCallback];
            }];
            
            if ([context hasChanges]) {
                
                NSError *error = nil;
                [context save:&error];
            }
        }];
    }];
}

@end
