//
//  NSString+UrlEncode.m
//  WOTPivot
//
//  Created on 2/13/19.
//  Copyright © 2019. All rights reserved.
//

#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)

+ (NSString *)urlEncode:(NSString *)string {
    NSString *encodedString = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes( NULL,
                                                                                                     (CFStringRef) string,
                                                                                                     NULL,
                                                                                                     CFSTR("%;/?¿:@&=$+,[]#!'()*<> \"\n"),
                                                                                                     kCFStringEncodingUTF8);
    return encodedString;
}

@end
