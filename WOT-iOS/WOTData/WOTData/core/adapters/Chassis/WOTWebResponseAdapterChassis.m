//
//  WOTWebResponseAdapterChassis.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterChassis.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>

@implementation WOTWebResponseAdapterChassis

- (void)parseData:(id)data error:(NSError *)error {

    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankChassesDictionary = [data[WOT_KEY_DATA] copy];
    
    NSArray *tankChassisArray = [tankChassesDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankChassisArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankChassisJSON = tankChassesDictionary[key];
            if (![tankChassisJSON isKindOfClass:[NSDictionary class]]){
                
                debugError(@"error while parsing");
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankChassisJSON[WOT_KEY_MODULE_ID]];
            Tankchassis *tankChasses = [Tankchassis findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tankChasses fillPropertiesFromDictionary:tankChassisJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}


@end
