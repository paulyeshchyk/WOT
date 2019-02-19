//
//  WOTWebResponseAdapterTanks.m
//  WOT-iOS
//
//  Created on 6/18/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWebResponseAdapterTanks.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import "NSManagedObject+FillProperties.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWebResponseAdapterTanks

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tanksDictionary = data[WOTApiKeys.data];
    
    NSArray *tanksArray = [tanksDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];

    [context performBlock:^{
        
        [tanksArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankJSON = tanksDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.tank_id,tankJSON[WOTApiKeys.tank_id]];
            Tanks *tank = (Tanks *)[Tanks findOrCreateObjectWithPredicate:predicate context:context];
            [tank fillPropertiesFromDictionary:tankJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
