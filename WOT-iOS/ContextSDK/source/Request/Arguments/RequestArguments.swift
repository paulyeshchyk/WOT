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
    typealias ArgumentsType = [Swift.AnyHashable: Any]

    var contextPredicate: ContextPredicateProtocol? { get set }
    var allValues: ArgumentsType { get }

    func setValues(_ values: Any, forKey: AnyHashable)
}

// MARK: - RequestArguments

open class RequestArguments: RequestArgumentsProtocol, CustomStringConvertible, MD5Protocol {

    public var contextPredicate: ContextPredicateProtocol?
    public var MD5: String { uuid.MD5 }

    public var description: String {
        "[\(type(of: self))]: \(String(describing: allValues))"
    }

    public var allValues: ArgumentsType = ArgumentsType()

    private let uuid = UUID()

    // MARK: Public

    public func setValues(_ values: Any, forKey: AnyHashable) {
        allValues[forKey] = values
    }
}
