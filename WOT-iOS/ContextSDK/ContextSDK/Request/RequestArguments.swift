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

open class RequestArguments: RequestArgumentsProtocol, MD5Protocol, CustomStringConvertible {

    private var dictionary = ArgumentsType()

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    public var description: String { "\(type(of: self)): \(String(describing: dictionary))" }

    required public init() {
        
    }
    required public convenience init(_ dictionary: ArgumentsType) {
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
}
