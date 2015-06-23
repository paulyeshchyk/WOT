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

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath;
+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath fieldDescription:(NSString *)fieldDescription;

@end

