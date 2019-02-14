//
//  String_UrlEncode.swift
//  WOTPivot
//
//  Created on 2/11/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

extension String {
    public func urlEncoded() -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn:"%;/?¿:@&=$+,[]#!'()*<> \"\n").inverted
        return self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
}
