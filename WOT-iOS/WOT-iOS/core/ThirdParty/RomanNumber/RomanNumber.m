//
//  RomanNumber.m
//  roman_converter
//
//  Created by Kuznetsov Mikhail on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RomanNumber.h"
#import "NSString+RomanUtils.h"

static NSDictionary *ROMAN_ARABIC = nil;
static NSDictionary *ARABIC_ROMAN = nil;


@implementation RomanNumber

@synthesize number = _number;
@synthesize roman = _roman;

+ (NSDictionary *)romanArabic
{
    if (!ROMAN_ARABIC){
        ROMAN_ARABIC = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:1], @"I",
                        [NSNumber numberWithInt:5], @"V",
                        [NSNumber numberWithInt:10], @"X",
                        [NSNumber numberWithInt:50], @"L",
                        [NSNumber numberWithInt:100], @"C",
                        [NSNumber numberWithInt:500], @"D",
                        [NSNumber numberWithInt:1000], @"M", nil];
    }
	return ROMAN_ARABIC;
}

+ (NSDictionary *)arabicRoman
{
    if (!ARABIC_ROMAN){
        ARABIC_ROMAN = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"M", [NSNumber numberWithInt:1000],
                        @"CM", [NSNumber numberWithInt:900],
                        @"D", [NSNumber numberWithInt:500],
                        @"CD", [NSNumber numberWithInt:400],
                        @"C", [NSNumber numberWithInt:100],
                        @"XC", [NSNumber numberWithInt:90],
                        @"L", [NSNumber numberWithInt:50],
                        @"XL", [NSNumber numberWithInt:40],
                        @"X", [NSNumber numberWithInt:10],
                        @"IX", [NSNumber numberWithInt:9],
                        @"V", [NSNumber numberWithInt:5],
                        @"IV", [NSNumber numberWithInt:4],
                        @"I", [NSNumber numberWithInt:1], nil];
    }
	return ARABIC_ROMAN;
}

- (NSNumber *)romanToArabic:(NSString *)romanNumber
{
    if ([NSString stringIsEmpty:romanNumber]) {
        [NSException raise:@"" format:@"%@", romanNumber];
    }
    NSMutableArray *res = [NSMutableArray array];
    for (NSInteger charIdx=0; charIdx < romanNumber.length; charIdx++){
        NSString *x = [NSString stringWithFormat:@"%c", [romanNumber characterAtIndex:charIdx]];
        NSNumber *n = [[RomanNumber romanArabic] objectForKey:x];
        if (n){
            if (res.count == 0){
                [res addObject:n];
            }
            else {
                if ([res lastObject] < n){
                    NSNumber *t = [NSNumber numberWithInt:([n intValue] - [(NSNumber *)[res lastObject] intValue])];
                    [res removeLastObject];
                    [res addObject:t];
                }
                else {
                    [res addObject:n];
                }
            }
        }
        else {
            [NSException raise:@"" format:@"%@", romanNumber];
        }
    }

    if (res.count){
        int sum = 0;
        for (NSNumber *i in res) {
            sum += [i intValue];
        }
        return [NSNumber numberWithInt:sum];
    }
    return [NSNumber numberWithInt:0];
}

- (NSString *)arabicToRoman:(NSNumber *)arabicNumber
{
    NSMutableArray *res = [NSMutableArray array];
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
        
    for (id key in [[[RomanNumber arabicRoman] allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject: sortOrder]])
    {
        int count = [arabicNumber intValue] / [key intValue];
        for (NSInteger i = 0; i < count; i++){
            [res addObject: [[RomanNumber arabicRoman] objectForKey:key]];
        }
        arabicNumber = [NSNumber numberWithInt:( [arabicNumber intValue] - [key intValue] * count )];
    }
    return [res componentsJoinedByString:@""];
}

- (id)initWithArabic:(NSNumber *)arabicNumber
{
    self = [super init];
    if (self){
        self.number = arabicNumber;
        self.roman = [self arabicToRoman:arabicNumber];
    }
    return self;
}

- (id)initWithRoman:(NSString *)romanNumber
{
    self = [super init];
    if (self){
        self.number = [self romanToArabic:romanNumber];
        self.roman = romanNumber;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.roman, self.number];
}

- (RomanNumber *)numberByAddingNumber:(RomanNumber *)number
{
    return [[RomanNumber alloc] initWithArabic:[NSNumber numberWithInt:([self.number intValue] + [number.number intValue] )]];
}

- (RomanNumber *)numberBySubstractingNumber:(RomanNumber *)number
{
    return [[RomanNumber alloc] initWithArabic:[NSNumber numberWithInt:([self.number intValue] - [number.number intValue] )]];
}

- (RomanNumber *)numberByMultiplyingNumber:(RomanNumber *)number
{
    return [[RomanNumber alloc] initWithArabic:[NSNumber numberWithInt:([self.number intValue] * [number.number intValue] )]];
}

- (RomanNumber *)numberByDividingNumber:(RomanNumber *)number
{
    return [[RomanNumber alloc] initWithArabic:[NSNumber numberWithInt:([self.number intValue] / [number.number intValue] )]];
}
@end
