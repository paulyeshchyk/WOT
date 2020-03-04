//
//  WOTRequestArguments.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTRequestArguments: NSObject {
    @objc
    public private(set) var dictionary = [AnyHashable: Any]()
    
    @objc
    convenience public init(_ dictionary: [AnyHashable: Any]) {

        self.init()

        dictionary.keys.forEach {
            if let plainArray = dictionary[$0] as? String {
                let joinedString = plainArray.components(separatedBy: ",")
                self.dictionary[$0] = joinedString
            }
        }
    }
    
    @objc
    public func setValues(_ values: Any, forKey: AnyHashable) {
        dictionary[forKey] = values
    }
    
    @objc
    public func buildQuery() -> String {
        return dictionary.asURLQueryString()
    }
    
    @objc
    public override var hash: Int {

        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var hasher = Hasher()
            hasher.combine(data)
            return hasher.finalize()

        } catch {
            return 0
        }
    }
    
}
