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

- (NSError *)parseData:(NSData *)data error:(NSError *) error nestedRequestsCallback:(void (^)(NSArray<JSONMappingNestedRequest *> * _Nullable))nestedRequestsCallback {
    
    return [data parseAsJSON:^(NSDictionary * _Nullable json) {

        NSArray *tankRadiosArray = [json allKeys];
        id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
        NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
        [context performBlock:^{
            
            [tankRadiosArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *tankRadiosJSON = json[key];
                if (![tankRadiosJSON isKindOfClass:[NSDictionary class]]) {
                    
                    debugError(@"error while parsing");
                    return;
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WGJsonFields.module_id,tankRadiosJSON[WGJsonFields.module_id]];
                Tankradios *tankradios = (Tankradios *)[Tankradios findOrCreateObjectWithPredicate:predicate context:context];
                [tankradios mappingFromJSON:tankRadiosJSON into: context completion: nestedRequestsCallback];
            }];
            
            if ([context hasChanges]) {
                
                NSError *error = nil;
                [context save:&error];
            }
        }];
    }];
}

@end
