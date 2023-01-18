//
//  RequestParadigm.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public class RequestArgumentsBuilder: NSObject, RequestArgumentsBuilderProtocol {

    public var modelClass: ModelClassType
    private let contextPredicate: ContextPredicateProtocol?

    // MARK: - NSObject

    override public var description: String {
        let result: String = "RequestArguments: \(type(of: modelClass))"
        return result
    }

    public var MD5: String { uuid.MD5 }

    // MARK: - MD5Protocol

    private let uuid = UUID()

    // MARK: Lifecycle

    public init(modelClass T: ModelClassType, contextPredicate: ContextPredicateProtocol?) {
        self.contextPredicate = contextPredicate
        modelClass = T.self
    }

    // MARK: Public

    public func buildRequestArguments(keypathPrefix: String?, httpQueryItemName: String?) -> RequestArguments {
        let arguments = RequestArguments()

        let keyPaths = modelClass.fieldsKeypaths().compactMap {
            self.addPreffix(keypathPrefix: keypathPrefix, to: $0)
        }

        if let httpQueryItemName = httpQueryItemName {
            arguments.setValues(keyPaths, forKey: httpQueryItemName)
        }

        contextPredicate?.expressions().forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }

        return arguments
    }

    // MARK: Private

    private func addPreffix(keypathPrefix: String?, to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }
}
