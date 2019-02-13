//
//  NSString+UrlEncode.h
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 2/13/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

#import "Foundation/Foundation.h"

@interface NSString (UrlEncode)
+ (NSString *)urlEncode:(NSString *)string;
@end

