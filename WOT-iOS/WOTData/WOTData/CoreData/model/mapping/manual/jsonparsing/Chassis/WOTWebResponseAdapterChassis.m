//
//  WOTWebResponseAdapterChassis.m
//  WOT-iOS
//
//  Created on 6/23/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterChassis.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterChassis

- (void)parseData:(id)data error:(NSError *)error binary:(NSData * _Nullable)binary{

    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankChassesDictionary = [data[WOTApiKeys.data] copy];
    
    NSArray *tankChassisArray = [tankChassesDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankChassisArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankChassisJSON = tankChassesDictionary[key];
            if (![tankChassisJSON isKindOfClass:[NSDictionary class]]){
                
                debugError(@"error while parsing");
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.module_id,tankChassisJSON[WOTApiKeys.module_id]];
            Tankchassis *tankChasses = (Tankchassis *)[Tankchassis findOrCreateObjectWithPredicate:predicate context:context];
            [tankChasses mappingFrom:tankChassisJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}


@end