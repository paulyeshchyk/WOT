//
//  RequestParadigm.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol RequestParadigmProtocol {
    var clazz: AnyClass { get }
    func predicate() -> ContextPredicate?
    func buildRequestArguments() -> RequestArguments
}

// MARK: - Extension RequestParadigmProtocol

public class RequestParadigm: NSObject, RequestParadigmProtocol {

    // MARK: - Public

    public var requestPredicateComposer: RequestPredicateComposerProtocol?

    // MARK: - RequestParadigmProtocol

    public let clazz: AnyClass
    private let keypathPrefix: String?
    private let httpQueryItemName: String

    private var primaryKeys: [ContextExpression] {
        return predicate()?.expressions(pkType: nil)?.compactMap { $0 } ?? []
    }

    public func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }

    public init(clazz: AnyClass, requestPredicateComposer: RequestPredicateComposerProtocol?, keypathPrefix: String?, httpQueryItemName: String) {
        self.clazz = clazz
        self.requestPredicateComposer = requestPredicateComposer
        self.keypathPrefix = keypathPrefix
        self.httpQueryItemName = httpQueryItemName
    }

    deinit {
        //
    }
    
    public func buildRequestArguments() -> RequestArguments {
        let keyPaths = clazz.fieldsKeypaths().compactMap {
            self.addPreffix(to: $0)
        }

        let arguments = RequestArguments()
        arguments.setValues(keyPaths, forKey: httpQueryItemName)
        primaryKeys.forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }
        return arguments
    }

    public func predicate() -> ContextPredicate? {
        return requestPredicateComposer?.build()?.requestPredicate
    }

    override public var description: String {
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
