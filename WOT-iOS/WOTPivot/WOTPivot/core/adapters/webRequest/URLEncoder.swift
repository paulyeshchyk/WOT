//
//  URLEncoder.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 1/15/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

//        NSString *encodedString = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes( NULL,
//                                                                                                          (CFStringRef) string,
//                                                                                                          NULL,
//                                                                                                          CFSTR("%;/?¿:@&=$+,[]#!'()*<> \"\n"),
//                                                                                                          kCFStringEncodingUTF8);

@objc
open class URLEncoder: NSObject {
    open static func encode(string: String) -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn:"%;/?¿:@&=$+,[]#!'()*<> \"\n").inverted
        return string.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
}
