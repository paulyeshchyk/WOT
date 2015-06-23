//
//  WOTWebResponseAdapterChassis.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWebResponseAdapterChassis.h"
#import "Tankchassis.h"

@implementation WOTWebResponseAdapterChassis

- (void)parseData:(id)data error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *tankChassesDictionary = data[WOT_KEY_DATA];
    
    NSArray *tankChassisArray = [tankChassesDictionary allKeys];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] workManagedObjectContext];
    for (NSString *key in tankChassisArray) {
        
        NSDictionary *tankChassisJSON = tankChassesDictionary[key];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_MODULE_ID,tankChassisJSON[WOT_KEY_MODULE_ID]];
        Tankchassis *tankChasses = [Tankchassis findOrCreateObjectWithPredicate:predicate inManagedObjectContext:context];
        [tankChasses fillPropertiesFromDictionary:tankChassisJSON];
    }
    
    if ([context hasChanges]) {
        
        NSError *error = nil;
        [context save:&error];
    }
}

@end
