//
//  RequestParadigm.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

// MARK: - Extension RequestParadigmProtocol

public class RequestParadigm: NSObject, RequestParadigmProtocol {
    // MARK: - NSObject

    override public var description: String {
        var result: String = "RequestArguments: \(typeDescription)"
        primaryKeys.forEach {
            result += " key:\($0)"
        }
        if let prefix = keypathPrefix {
            result += " prefix:\(prefix)"
        }
        return result
    }

    // MARK: - MD5Protocol
    public var MD5: String { uuid.MD5 }
    public let uuid: UUID = UUID()

    // MARK: - RequestParadigmProtocol

    public let modelClass: AnyClass

    // MARK: -

    private var requestPredicateComposer: RequestPredicateComposerProtocol?
    private let keypathPrefix: String?
    private let httpQueryItemName: String
    private let fieldsKeypaths: [String]
    private let typeDescription: String
    private var primaryKeys: [ContextExpression] {
        return predicate()?.expressions(pkType: nil)?.compactMap { $0 } ?? []
    }

    public init<T: RequestableProtocol>(modelClass: T.Type, requestPredicateComposer: RequestPredicateComposerProtocol?, keypathPrefix: String?, httpQueryItemName: String) {
        self.fieldsKeypaths = T.fieldsKeypaths()
        self.requestPredicateComposer = requestPredicateComposer
        self.keypathPrefix = keypathPrefix
        self.httpQueryItemName = httpQueryItemName

        self.modelClass = T.self
        typeDescription = String(describing: T.self)
    }

    public func buildRequestArguments() -> RequestArguments {
        let keyPaths = fieldsKeypaths.compactMap {
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

    // MARK: - private

    private func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }
}
