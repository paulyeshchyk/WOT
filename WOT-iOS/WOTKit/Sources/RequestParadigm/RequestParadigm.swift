//
//  RequestParadigm.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol RequestParadigmProtocol: Describable {
    var clazz: AnyClass { get set }
    var jsonAdapterLinker: JSONAdapterLinkerProtocol { get }
    var keypathPrefix: String? { get }
    var primaryKeys: [RequestExpression] { get }
    func addPreffix(to: String) -> String
    func requestPredicate() -> RequestPredicate?
}

public class RequestParadigm: NSObject, RequestParadigmProtocol {
    // MARK: - Public

    public var requestPredicateComposer: RequestPredicateComposerProtocol?

    // MARK: - RequestParadigmProtocol

    public var keypathPrefix: String?
    public var clazz: AnyClass
    public var jsonAdapterLinker: JSONAdapterLinkerProtocol

    public var primaryKeys: [RequestExpression] {
        return requestPredicate()?.expressions()?.compactMap { $0 } ?? []
    }

    public var wotDescription: String {
        var result: String = "RequestArguments: \(String(describing: clazz))"
        primaryKeys.forEach {
            result += " key:\($0)"
        }
        if let prefix = keypathPrefix {
            result += " prefix:\(prefix)"
        }
        return result
    }

    public func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }

    public init(clazz clazzTo: AnyClass, adapter: JSONAdapterLinkerProtocol, requestPredicateComposer rpc: RequestPredicateComposerProtocol?, keypathPrefix kp: String?) {
        clazz = clazzTo
        jsonAdapterLinker = adapter
        requestPredicateComposer = rpc
        keypathPrefix = kp
    }

    public func requestPredicate() -> RequestPredicate? {
        return requestPredicateComposer?.build()?.requestPredicate
    }
}
