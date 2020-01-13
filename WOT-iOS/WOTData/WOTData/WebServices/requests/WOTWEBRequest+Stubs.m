//
//  WOTWEBRequest+Stubs.m
//  WOTData
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

#import "WOTWEBRequest+Stubs.h"

@implementation WOTWEBRequestTanks (Fake)
- (NSString *)stubJSON {
    return @"tanks.json";
}
@end

@implementation WOTWebRequestTankChassis (Fake)
- (NSString *)stubJSON {
    return @"chassis.json";
}
@end

@implementation WOTWebRequestTankRadios (Fake)
- (NSString *)stubJSON {
    return @"tankradios.json";
}
@end

@implementation WOTWebRequestTankGuns (Fake)
- (NSString *)stubJSON {
    return @"tankguns.json";
}
@end


@implementation WOTWEBRequestTankProfile (Fake)
- (NSString *)stubJSON {
    return @"vehicleprofile.json";
}
@end

@implementation WOTWebRequestTankTurrets (Fake)
- (NSString *)stubJSON {
    return @"tankturrets.json";
}
@end

@implementation WOTWEBRequestTankVehicles (Fake)
- (NSString *)stubJSON {
    return @"vehicles.json";
}
@end

@implementation WOTWEBRequestTankEngines (Fake)
- (NSString *)stubJSON {
    return @"tankengines.json";
}
@end

