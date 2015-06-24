//
//  WOTTankDetailField.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTTankDetailField : NSObject

@property (nonatomic, copy)NSString *fieldPath;
@property (nonatomic, copy)NSString *fieldDescriotion;
@property (nonatomic, copy)NSString *query;


+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath;
+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query;
+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query fieldDescription:(NSString *)fieldDescription;

@end

