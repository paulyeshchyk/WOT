//
//  WOTRequestArguments.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol RequestArgumentsProtocol {
    init(_ dictionary: JSON)
    func setValues(_ values: Any, forKey: AnyHashable)
    func buildQuery(_ custom: JSON) -> String
}

public typealias ArgumentsType = Swift.Dictionary<Swift.AnyHashable, Any>

open class RequestArguments: NSObject, RequestArgumentsProtocol {

    private var dictionary = ArgumentsType()

    public override var description: String {
        dictionary.debugOutput()
    }

    required convenience public init(_ dictionary: ArgumentsType) {
        self.init()

        dictionary.keys.forEach {
            if let plainArray = dictionary[$0] as? String {
                let joinedString = plainArray.components(separatedBy: ",")
                self.dictionary[$0] = joinedString
            }
        }
    }

    public func setValues(_ values: Any, forKey: AnyHashable) {
        dictionary[forKey] = values
    }

    public func buildQuery(_ custom: ArgumentsType = [:]) -> String {
        var mixture = custom
        mixture.append(with: dictionary)
        return mixture.asURLQueryString()
    }

    open override var hash: Int {
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])

        var hasher = Hasher()
        hasher.combine(data)
        let result = hasher.finalize()
        return result
    }
}
