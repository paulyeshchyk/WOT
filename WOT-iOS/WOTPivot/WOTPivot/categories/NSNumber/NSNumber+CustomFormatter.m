//
//  NSNumber+CustomFormatter.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/24/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSNumber+CustomFormatter.h"

@implementation NSNumber (CustomFormatter)

- (NSString *)suffixNumber {
    
    long long num = [self longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log(num) / log(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}
@end
