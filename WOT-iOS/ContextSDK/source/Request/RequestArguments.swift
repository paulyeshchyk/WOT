//
//  WOTRequestArguments.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestArgumentsProtocol

@objc
public protocol RequestArgumentsProtocol {
    init(_ dictionary: JSON)
    func setValues(_ values: Any, forKey: AnyHashable)
    func buildQuery(_ custom: JSON) -> String
}

public typealias ArgumentsType = [Swift.AnyHashable: Any]

// MARK: - RequestArguments

@objc
open class RequestArguments: NSObject, RequestArgumentsProtocol, MD5Protocol {

    public var MD5: String { uuid.MD5 }

    override public var description: String { "\(type(of: self)): \(String(describing: dictionary))" }

    private var dictionary = ArgumentsType()

    private let uuid = UUID()

    // MARK: Lifecycle

    public required convenience init(_ dictionary: ArgumentsType) {
        self.init()

        dictionary.keys.forEach {
            if let plainArray = dictionary[$0] as? String {
                let joinedString = plainArray.components(separatedBy: ",")
                self.dictionary[$0] = joinedString
            }
        }
    }

    // MARK: Public

    public func setValues(_ values: Any, forKey: AnyHashable) {
        dictionary[forKey] = values
    }

    public func buildQuery(_ custom: ArgumentsType = [:]) -> String {
        var mixture = custom
        mixture.append(with: dictionary)
        return mixture.asURLQueryString()
    }

}
