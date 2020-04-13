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

- (NSError *)parseData:(NSData *)data jsonLinksCallback:(void (^)(NSArray<WOTJSONLink *> * _Nullable))nestedRequestsCallback {
    
    return [data parseAsJSON:^(NSDictionary * _Nullable json) {

        NSArray *tankGunsArray = [json allKeys];
        
        id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
        NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
        [context performBlock:^{
            
            [tankGunsArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *tankGunsJSON = json[key];
                if ([tankGunsJSON isKindOfClass:[NSDictionary class]]) {
                    PrimaryKey *pk = [[PrimaryKey alloc] initWithName:WGJsonFields.module_id value:tankGunsJSON[WGJsonFields.module_id] predicateFormat:@"%K == %@"];
                    Tankguns *tankGuns = (Tankguns *)[Tankguns findOrCreateObjectWithPredicate:pk.predicate context:context];
                    [tankGuns mappingFromJSON:tankGunsJSON into: context parentPrimaryKey: pk jsonLinksCallback:nestedRequestsCallback];
                }
            }];
            
            if ([context hasChanges]) {
                
                NSError *error = nil;
                [context save:&error];
            }
        }];
    }];
}

@end
