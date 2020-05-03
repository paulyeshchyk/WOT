//
//  WOTWEBRequest+Stubs.m
//  WOTData
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

#import "WOTWEBRequest+Stubs.h"
#import "NSBundle+LanguageBundle.h"
#import <objc/runtime.h>

@interface WOTWEBRequest(Stubs_Private)
@end

static const void *WOTWEBRequestStubJSONKey = &WOTWEBRequestStubJSONKey;

@implementation WOTWEBRequest (Stubs)

- (void)setStubJSON:(NSString * _Nonnull)stubJSON {
    objc_setAssociatedObject(self, WOTWEBRequestStubJSONKey, stubJSON, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)stubJSON {
    return objc_getAssociatedObject(self, &WOTWEBRequestStubJSONKey);
}

- (NSData *)stubs {

    NSData *result = nil;

    NSString *filename = self.stubJSON;

    if ([filename length] > 0) {
        NSString *path = WOTResourcePath(filename);
        NSError* error = nil;
        result = [NSData dataWithContentsOfFile:path options: 0 error: &error];
        if (error) {
            NSLog(@"%@",error);
        }
    }

    return result;
}

@end


//@implementation WOTWEBRequestTanks (Fake)
//- (NSString *)stubJSON {
//    return @"tanks.json";
//}
//@end

//@implementation WOTWebRequestTankChassis (Fake)
//- (NSString *)stubJSON {
//    return @"chassis.json";
//}
//@end

//@implementation WOTWebRequestTankRadios (Fake)
//- (NSString *)stubJSON {
//    return @"tankradios.json";
//}
//@end

//@implementation WOTWebRequestTankGuns (Fake)
//- (NSString *)stubJSON {
//    return @"tankguns.json";
//}
//@end


//@implementation WOTWEBRequestTankProfile (Fake)
//- (NSString *)stubJSON {
//    return @"vehicleprofile.json";
//}
//@end

//@implementation WOTWebRequestTankTurrets (Fake)
//- (NSString *)stubJSON {
//    return @"tankturrets.json";
//}
//@end

//@implementation WOTWEBRequestTankVehicles (Fake)
//- (NSString *)stubJSON {
//    return @"vehicles.json";
//}
//@end

//@implementation WOTWEBRequestTankEngines (Fake)
//- (NSString *)stubJSON {
//    return @"tankengines.json";
//}
//@end

