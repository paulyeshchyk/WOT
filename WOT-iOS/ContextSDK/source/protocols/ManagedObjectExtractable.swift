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
    var jsonKeyPath: KeypathType? { get }
}

public extension ManagedObjectExtractable {

    func extract(json: JSON, key: AnyHashable, modelClass: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol?) throws -> JSONExtraction {
        guard let jsonElement = json[key] as? JSON else {
            throw JSONExtraction.JSONAdapterLinkerExtractionErrors.invalidJSONForKey(key)
        }

        let managedObjectJSON: JSON?

        if let keyPath = jsonKeyPath {
            managedObjectJSON = jsonElement[keyPath] as? JSON
        } else {
            managedObjectJSON = jsonElement
        }

        guard let managedObjectJSON = managedObjectJSON else {
            throw JSONExtraction.JSONAdapterLinkerExtractionErrors.jsonWasNotExtracted(jsonElement)
        }

        let primaryKeyPath = modelClass.primaryKeyPath(forType: linkerPrimaryKeyType)
        let ident = managedObjectJSON[primaryKeyPath] ?? key

        #warning("2b refactored")
        let parents = contextPredicate?.parentObjectIDList

        let requestPredicate = ContextPredicate(parentObjectIDList: parents)
        requestPredicate[.primary] = modelClass.primaryKey(forType: linkerPrimaryKeyType, andObject: ident)

        let jsonCollection = try JSONCollection(element: managedObjectJSON)
        return JSONExtraction(requestPredicate: requestPredicate, jsonCollection: jsonCollection)
    }
}

// MARK: - JSONExtraction

public struct JSONExtraction {

    public let requestPredicate: ContextPredicateProtocol
    public let jsonCollection: JSONCollectionProtocol?

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
