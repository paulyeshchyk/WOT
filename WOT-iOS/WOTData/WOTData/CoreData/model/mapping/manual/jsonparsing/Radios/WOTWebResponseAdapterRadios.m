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

- (void)parseJSON:(NSDictionary *)json error:(NSError *)error {
   
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    NSDictionary *tankRadiosDictionary = json[WGJsonFields.data];
    
    NSArray *tankRadiosArray = [tankRadiosDictionary allKeys];
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider workManagedObjectContext];
    [context performBlock:^{
        
        [tankRadiosArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *tankRadiosJSON = tankRadiosDictionary[key];
            if (![tankRadiosJSON isKindOfClass:[NSDictionary class]]) {
                
                debugError(@"error while parsing");
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WGJsonFields.module_id,tankRadiosJSON[WGJsonFields.module_id]];
            Tankradios *tankradios = (Tankradios *)[Tankradios findOrCreateObjectWithPredicate:predicate context:context];
            [tankradios mappingFrom:tankRadiosJSON];
        }];
        
        if ([context hasChanges]) {
            
            NSError *error = nil;
            [context save:&error];
        }
    }];
}

@end
