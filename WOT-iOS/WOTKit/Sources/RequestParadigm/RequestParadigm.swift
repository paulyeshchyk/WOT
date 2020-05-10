//
//  RequestParadigm.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol RequestParadigmProtocol {
    var clazz: AnyClass { get set }
    var primaryKeys: [RequestExpression] { get }
    func addPreffix(to: String) -> String
}

public class RequestParadigm: NSObject, RequestParadigmProtocol {

    // MARK: - Public

    public var requestPredicate: RequestPredicate?
    public var keypathPrefix: String?
    public var clazz: AnyClass

    // MARK: - RequestParadigmProtocol

    public var primaryKeys: [RequestExpression] {
        return requestPredicate?.expressions()?.compactMap { $0 } ?? []
    }

    public func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }

    public init(clazz clazzTo: AnyClass, requestPredicate rp: RequestPredicate?, keypathPrefix kp: String?) {
        clazz = clazzTo
        requestPredicate = rp
        keypathPrefix = kp
    }
}

extension RequestParadigm: Describable {
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
}
