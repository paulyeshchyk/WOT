//
//  WOTTankListSettingField.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingField.h"

@implementation WOTTankListSettingField

- (id)initWithKey:(NSString *)key value:(NSString *)value{
    
    self = [super init];
    if (self){
        
        self.key = key;
        self.value = value;
    }
    return self;
}

@end

