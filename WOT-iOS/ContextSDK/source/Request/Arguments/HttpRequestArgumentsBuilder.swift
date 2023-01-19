//
//  HttpRequestArgumentsBuilder.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public class HttpRequestArgumentsBuilder: NSObject, HttpRequestArgumentsBuilderProtocol {

    public var keyPaths: [String]?
    public var contextPredicate: ContextPredicateProtocol?
    public var keypathPrefix: String?
    public var httpQueryItemName: String?

    // MARK: - NSObject

    override public var description: String {
        return "\(type(of: self))"
    }

    public var MD5: String { uuid.MD5 }

    // MARK: - MD5Protocol

    private let uuid = UUID()

    // MARK: Public

    public func build() -> RequestArgumentsProtocol {
        //
        let arguments = RequestArguments()
        arguments.contextPredicate = contextPredicate

        let keyPaths = keyPaths?.compactMap {
            self.addPreffix(keypathPrefix: keypathPrefix, to: $0)
        } ?? []

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
