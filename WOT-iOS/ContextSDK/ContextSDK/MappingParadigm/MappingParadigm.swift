//
//  RequestParadigm.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol MappingParadigmProtocol {
    var clazz: AnyClass { get set }
    var jsonAdapterLinker: JSONAdapterLinkerProtocol { get }
    var keypathPrefix: String? { get }
    var primaryKeys: [RequestExpression] { get }
    func addPreffix(to: String) -> String
    func requestPredicate() -> RequestPredicate?
}

// MARK: - Extension RequestParadigmProtocol

extension MappingParadigmProtocol {
    public func buildRequestArguments() -> RequestArguments {
        let keyPaths = clazz.classKeypaths().compactMap {
            self.addPreffix(to: $0)
        }

        let arguments = RequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        primaryKeys.forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }
        return arguments
    }
}

public class MappingParadigm: NSObject, MappingParadigmProtocol {
    // MARK: - Public

    public var requestPredicateComposer: RequestPredicateComposerProtocol?

    // MARK: - RequestParadigmProtocol

    public var keypathPrefix: String?
    public var clazz: AnyClass
    public var jsonAdapterLinker: JSONAdapterLinkerProtocol

    public var primaryKeys: [RequestExpression] {
        return requestPredicate()?.expressions(pkType: nil)?.compactMap { $0 } ?? []
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