//
//  String_UrlEncode.swift
//  WOTPivot
//
//  Created on 2/11/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
public extension NSString {
    
    @objc
    func urlEncoded() -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn:"%;/?¿:@&=$+,[]#!'()*<> \"\n").inverted
        return self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
}
