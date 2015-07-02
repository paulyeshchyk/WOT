//
//  WOTWebResponseAdapterGuns.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterGuns.h"
#import "Tankguns.h"

@implementation WOTWebResponseAdapterGuns

- (void)parseData:(id)data error:(NSError *)error {

    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankGunsDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankGunsArray = [tankGunsDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    [context performBlock:^{
        
        for (NSString *key in tankGunsArray) {
            
            NSDictionary *tankGunsJSON = tankGunsDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankGunsJSON[WOT_KEY_MODULE_ID]];
            Tankguns *tankGuns = [Tankguns findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tankGuns fillPropertiesFromDictionary:tankGunsJSON];
        }
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
