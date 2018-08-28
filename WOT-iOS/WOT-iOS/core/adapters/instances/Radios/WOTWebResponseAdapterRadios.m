//
//  WOTWebResponseAdapterRadios.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterRadios.h"
#import <WOTData/WOTData.h>

@implementation WOTWebResponseAdapterRadios

- (void)parseData:(id)data error:(NSError *)error {
   
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    NSDictionary *tankRadiosDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankRadiosArray = [tankRadiosDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankRadiosArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankRadiosJSON = tankRadiosDictionary[key];
            if (![tankRadiosJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }
            
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
