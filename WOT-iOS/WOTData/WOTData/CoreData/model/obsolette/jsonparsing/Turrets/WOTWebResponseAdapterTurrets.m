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
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterTurrets

- (void)parseJSON:(NSDictionary * __nonnull)json nestedRequestsCallback:(void (^ _Nullable)(NSArray<JSONMappingNestedRequest *> * _Nullable))nestedRequestsCallback {
    
    NSDictionary *tankTurretsDictionary = json[WGJsonFields.data];
    
    NSArray *tankTurretsArray = [tankTurretsDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankTurretsArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankTurretsJSON = tankTurretsDictionary[key];
            if (![tankTurretsJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", WGJsonFields.module_id, tankTurretsJSON[WGJsonFields.module_id]];
            Tankturrets *tankturrets = (Tankturrets *)[Tankturrets findOrCreateObjectWithPredicate:predicate context:context];
            [tankturrets mappingFromJSON:tankTurretsJSON into: context completion:^(NSArray<JSONMappingNestedRequest *> * _Nullable requests) {
                //
            }];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}


@end
