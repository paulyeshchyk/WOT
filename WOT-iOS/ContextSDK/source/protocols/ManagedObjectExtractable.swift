//
//  ManagedObjectExtractable.swift
//  ContextSDK
//
//  Created by Paul on 3.01.23.
//

// MARK: - ManagedObjectExtractable

@objc
public protocol ManagedObjectExtractable {
    var linkerPrimaryKeyType: PrimaryKeyType { get }
    func extractJSON(from: JSON) -> JSON?
}

public extension ManagedObjectExtractable {
    func extract(json: JSON, key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol?) throws -> JSONExtraction {
        guard let json = json[key] as? JSON else {
            throw JSONExtraction.JSONAdapterLinkerExtractionErrors.invalidJSONForKey(key)
        }

        guard let extractedJSON = extractJSON(from: json) else {
            throw JSONExtraction.JSONAdapterLinkerExtractionErrors.jsonWasNotExtracted(json)
        }

        let primaryKeyPath = modelClazz.primaryKeyPath(forType: linkerPrimaryKeyType)
        let ident = extractedJSON[primaryKeyPath] ?? key

        #warning("2b refactored")
        let parents = contextPredicate?.parentObjectIDList

        let requestPredicate = ContextPredicate(parentObjectIDList: parents)
        requestPredicate[.primary] = modelClazz.primaryKey(forType: linkerPrimaryKeyType, andObject: ident)

        let jsonCollection = try JSONCollection(element: extractedJSON)
        return JSONExtraction(requestPredicate: requestPredicate, json: jsonCollection)
    }
}

// MARK: - JSONExtraction

public struct JSONExtraction {

    public let requestPredicate: ContextPredicateProtocol
    public let json: JSONCollectionProtocol?

    enum JSONAdapterLinkerExtractionErrors: Error, CustomStringConvertible {
        case invalidJSONForKey(AnyHashable)
        case jsonWasNotExtracted(JSON)

        public var description: String {
            switch self {
            case .invalidJSONForKey(let key): return "[\(type(of: self))]: Invalid json for key: \(key)"
            case .jsonWasNotExtracted(let json): return "[\(type(of: self))]: json was not extracted from: \(json)"
            }
        }
    }
}
