//
//  RomanNumber.h
//  roman_converter
//
//  Created by Kuznetsov Mikhail on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RomanNumber : NSObject
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSString *roman;
- (id)initWithRoman:(NSString *)romanNumber;
- (id)initWithArabic:(NSNumber *)arabicNumber;
- (NSNumber *)romanToArabic:(NSString *)romanNumber;
- (NSString *)arabicToRoman:(NSNumber *)arabicNumber;
- (RomanNumber *)numberByAddingNumber:(RomanNumber *)number;
- (RomanNumber *)numberBySubstractingNumber:(RomanNumber *)number;
- (RomanNumber *)numberByMultiplyingNumber:(RomanNumber *)number;
- (RomanNumber *)numberByDividingNumber:(RomanNumber *)number;

@end
