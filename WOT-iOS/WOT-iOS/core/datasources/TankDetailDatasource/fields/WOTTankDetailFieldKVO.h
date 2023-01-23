//
//  WOTTankDetailFieldKVO.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailField.h"

@interface WOTTankDetailFieldKVO : WOTTankDetailField

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath query:(NSString *)query;

@property (nonatomic, copy)NSString *fieldPath;
@property (nonatomic, copy)NSString *fieldDescriotion;
@property (nonatomic, copy)NSString *query;



@end
