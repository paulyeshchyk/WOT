//
//  WOTWebResponseAdapterRadios.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterRadios.h"
#import "Tankradios.h"

@implementation WOTWebResponseAdapterRadios

- (void)parseData:(id)data error:(NSError *)error {
   
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    NSDictionary *tankRadiosDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankRadiosArray = [tankRadiosDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    [context performBlock:^{
        
        [tankRadiosArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankRadiosJSON = tankRadiosDictionary[key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankRadiosJSON[WOT_KEY_MODULE_ID]];
            Tankradios *tankradios = [Tankradios findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
            [tankradios fillPropertiesFromDictionary:tankRadiosJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
