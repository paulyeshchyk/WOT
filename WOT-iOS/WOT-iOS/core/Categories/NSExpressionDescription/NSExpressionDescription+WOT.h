//
//  NSExpressionDescription+WOT.h
//  WOT-iOS
//
//  Created on 7/9/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * WOTTankDetailFieldExpressionUsedForSingleObject;

@interface NSExpressionDescription (WOT)

+ (NSExpressionDescription *)valueExpressionDescriptionForField:(NSString *)field;
+ (NSExpressionDescription *)maxExpressionDescriptionForField:(NSString *)field;
+ (NSExpressionDescription *)averageExpressionDescriptionForField:(NSString *)field;

@end
