//
//  WOTTankDetailFieldKVO.h
//  WOT-iOS
//
//  Created on 6/25/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailField.h"

@interface WOTTankDetailFieldKVO : WOTTankDetailField

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query;

@property (nonatomic, copy)NSString *fieldPath;
@property (nonatomic, copy)NSString *fieldDescriotion;
@property (nonatomic, copy)NSString *query;



@end
