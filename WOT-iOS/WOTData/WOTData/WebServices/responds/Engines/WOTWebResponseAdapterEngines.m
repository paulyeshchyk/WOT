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

- (NSError *)request:(id<WOTRequestProtocol>)request parseData:(NSData *)data jsonLinkAdapter:(id<JSONLinksAdapter>)jsonLinkAdapter {
    
    return [data parseAsJSON:^(NSDictionary * _Nullable json) {

        NSArray *tankEnginesArray = [json allKeys];
        id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
        NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
        [context performBlock:^{
            
            [tankEnginesArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *tankEngineJSON = json[key];
                if ([tankEngineJSON isKindOfClass:[NSDictionary class]]) {
                    PrimaryKey *pk = [[PrimaryKey alloc] initWithName:@"module_id" value:tankEngineJSON[WGJsonFields.module_id] predicateFormat:@"%K == %@"];
                    Tankengines *tankEngines = (Tankengines *)[Tankengines findOrCreateObjectWithPredicate:pk.predicate context:context];
                    [tankEngines mappingFromJSON: tankEngineJSON into: context parentPrimaryKey:pk linksCallback:^(NSArray<WOTJSONLink *> * _Nullable links) {
                        [jsonLinkAdapter request:request adoptJsonLinks:links];
                    }];
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
