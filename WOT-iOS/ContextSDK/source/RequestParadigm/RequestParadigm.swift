//
//  RequestParadigm.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

// MARK: - Extension RequestParadigmProtocol

public class RequestParadigm: NSObject, RequestParadigmProtocol {

    // MARK: - RequestParadigmProtocol

    public let modelClass: RequestableProtocol.Type

    // MARK: - NSObject

    override public var description: String {
        var result: String = "RequestArguments: \(type(of: modelClass))"
        primaryKeys.forEach {
            result += " key:\($0)"
        }
        if let prefix = keypathPrefix {
            result += " prefix:\(prefix)"
        }
        return result
    }

    public var MD5: String { uuid.MD5 }

    // MARK: - MD5Protocol

    private let uuid = UUID()

    // MARK: -

    private var requestPredicateComposition: RequestPredicateCompositionProtocol
//    private var requestPredicateComposer: RequestPredicateComposerProtocol
    private let keypathPrefix: String?
    private let httpQueryItemName: String
    private let fieldsKeypaths: [String]

    private var primaryKeys: [ContextExpressionProtocol] {
        buildContextPredicate().expressions().compactMap { $0 }
    }

    // MARK: Lifecycle

    public init<T: RequestableProtocol>(modelClass _: T.Type, requestPredicateComposition: RequestPredicateCompositionProtocol, keypathPrefix: String?, httpQueryItemName: String) {
        fieldsKeypaths = T.fieldsKeypaths()
        self.requestPredicateComposition = requestPredicateComposition
        self.keypathPrefix = keypathPrefix
        self.httpQueryItemName = httpQueryItemName

        modelClass = T.self
    }

    // MARK: Public

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

    public func buildContextPredicate() -> ContextPredicateProtocol {
        return requestPredicateComposition.contextPredicate
    }

    // MARK: Private

    private func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }
}
