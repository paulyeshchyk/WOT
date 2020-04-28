//
//  WOTRequestArguments.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestArgumentsProtocol {
    @objc
    init(_ dictionary: JSON)

    @objc
    func setValues(_ values: Any, forKey: AnyHashable)

    @objc
    func buildQuery(_ custom: JSON) -> String
}

@objc
open class WOTRequestArguments: NSObject, WOTRequestArgumentsProtocol {
    @objc
    public private(set) var dictionary = JSON()

    @objc
    public override var description: String {
        return "\(dictionary)"
    }

    @objc
    required convenience public init(_ dictionary: JSON) {
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
    public func buildQuery(_ custom: JSON = [:]) -> String {
        var mixture = custom
        mixture.append(with: dictionary)
        return mixture.asURLQueryString()
    }

    @objc
    open override var hash: Int {
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
