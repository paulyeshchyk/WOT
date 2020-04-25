//
//  WOTTankListSettingField.h
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTankListSettingField : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign)BOOL ascending;

- (id)initWithKey:(NSString *)key value:(NSString *)value ascending:(BOOL)ascending;

@end
