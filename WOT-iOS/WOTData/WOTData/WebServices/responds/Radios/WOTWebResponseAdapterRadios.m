//
//  WOTWebResponseAdapterRadios.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterRadios.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterRadios

- (NSError *)request:(id<WOTRequestProtocol>)request parseData:(NSData *)data jsonLinkAdapter:(id<JSONLinksAdapter>)jsonLinkAdapter {
    
    return [data parseAsJSON:^(NSDictionary * _Nullable json) {

        NSArray *tankRadiosArray = [json allKeys];
        id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
        NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
        [context performBlock:^{
            
            [tankRadiosArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *tankRadiosJSON = json[key];
                if ([tankRadiosJSON isKindOfClass:[NSDictionary class]]) {
                    PrimaryKey *pk = [[PrimaryKey alloc] initWithName:WGJsonFields.module_id value:tankRadiosJSON[WGJsonFields.module_id] predicateFormat:@"%K == %@"];
                    Tankradios *tankradios = (Tankradios *)[Tankradios findOrCreateObjectWithPredicate:pk.predicate context:context];
                    [tankradios mappingFromJSON: tankRadiosJSON into: context parentPrimaryKey: pk linksCallback:^(NSArray<WOTJSONLink *> * _Nullable links) {
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
