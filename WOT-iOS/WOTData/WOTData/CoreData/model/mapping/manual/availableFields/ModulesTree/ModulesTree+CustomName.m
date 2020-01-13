//
//  ModulesTree+CustomName.m
//  WOT-iOS
//
//  Created on 9/10/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ModulesTree+CustomName.h"
#import "ModulesTree+FillProperties.h"

@implementation ModulesTree (CustomName)
@dynamic customName;

- (NSString *)customName {
    
    NSString *result = self.name;

//    WOTModuleType type = [self moduleType];
//    if ((type & WOTModuleTypeChassis) == WOTModuleTypeChassis) {
//        
//        result = [[self.nextChassis anyObject] performSelector:@selector(name_i18n)];
//    }
//    if ((type & WOTModuleTypeEngine) == WOTModuleTypeEngine) {
//        
//        result = [[self.nextEngines anyObject] performSelector:@selector(name_i18n)];
//    }
//    if ((type & WOTModuleTypeRadios) == WOTModuleTypeRadios) {
//        
//        result = [[self.nextRadios anyObject] performSelector:@selector(name_i18n)];
//    }
//    if ((type & WOTModuleTypeTurrets) == WOTModuleTypeTurrets) {
//        
//        result = [[self.nextTurrets anyObject] performSelector:@selector(name_i18n)];
//    }
//    if ((type & WOTModuleTypeGuns) == WOTModuleTypeGuns) {
//        
//        result = [[self.nextGuns anyObject] performSelector:@selector(name_i18n)];
//    }
//    if ((type & WOTModuleTypeTank) == WOTModuleTypeTank) {
//        
//        result = [[self.nextTanks anyObject] performSelector:@selector(name_i18n)];
//    }

    return result;
}


@end
