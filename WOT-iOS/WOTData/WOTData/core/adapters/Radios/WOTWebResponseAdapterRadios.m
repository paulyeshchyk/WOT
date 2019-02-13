//
//  WOTWebResponseAdapterRadios.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterRadios.h"
#import "WOTData.h"
#import <WOTPivot/WOTPivot.h>
#import "NSManagedObject+CoreDataOperations.h"
#import "NSManagedObject+FillProperties.h"

@implementation WOTWebResponseAdapterRadios

- (void)parseData:(id)data error:(NSError *)error {
   
    if (error) {
        
        debugError(@"%@",error.localizedDescription);
        return;
    }
    NSDictionary *tankRadiosDictionary = data[WOTApiKeys.data];
    
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
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOTApiKeys.module_id,tankRadiosJSON[WOTApiKeys.module_id]];
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
