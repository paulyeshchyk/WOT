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

- (NSError *)parseData:(NSData *)data jsonLinksCallback:(void (^)(NSArray<WOTJSONLink *> * _Nullable))nestedRequestsCallback {
    
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
                    [tankradios mappingFromJSON: tankRadiosJSON into: context parentPrimaryKey: pk jsonLinksCallback: nestedRequestsCallback];
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
