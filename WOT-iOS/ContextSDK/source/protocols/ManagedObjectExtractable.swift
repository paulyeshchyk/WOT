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

    func getJSONMaps(json: JSON, modelClass: PrimaryKeypathProtocol.Type, managedRefs: [ManagedRefProtocol]?) -> [JSONMapProtocol] {
        var result = [JSONMapProtocol]()
        for key in json.keys {
            do {
                let map = try getJSONMap(json: json, key: key, modelClass: modelClass, managedRefs: managedRefs)
                result.append(map)
            } catch {
                //
            }
        }
        return result
    }

    private func getJSONMap(json: JSON, key: AnyHashable, modelClass: PrimaryKeypathProtocol.Type, managedRefs: [ManagedRefProtocol]?) throws -> JSONMapProtocol {
        guard let jsonElement = json[key] as? JSON else {
            throw JSONAdapterLinkerExtractionErrors.invalidJSONForKey(key)
        }

        let managedObjectJSON: JSON?

        if let keyPath = jsonKeyPath {
            managedObjectJSON = jsonElement[keyPath] as? JSON
        } else {
            managedObjectJSON = jsonElement
        }

        guard let managedObjectJSON = managedObjectJSON else {
            throw JSONAdapterLinkerExtractionErrors.jsonWasNotExtracted(jsonElement)
        }

        #warning("2b refactored")
        let primaryKeyPath = modelClass.primaryKeyPath(forType: linkerPrimaryKeyType)
        let ident = managedObjectJSON[primaryKeyPath] ?? key

        let requestContextPredicate = ContextPredicate(managedRefs: managedRefs ?? [])
        requestContextPredicate[.primary] = modelClass.primaryKey(forType: linkerPrimaryKeyType, andObject: ident)

        return try JSONMap(element: managedObjectJSON, predicate: requestContextPredicate)
    }
}

// MARK: - JSONAdapterLinkerExtractionErrors

private enum JSONAdapterLinkerExtractionErrors: Error, CustomStringConvertible {
    case invalidJSONForKey(AnyHashable)
    case jsonWasNotExtracted(JSON)

    public var description: String {
        switch self {
        case .invalidJSONForKey(let key): return "[\(type(of: self))]: Invalid json for key: \(key)"
        case .jsonWasNotExtracted(let json): return "[\(type(of: self))]: json was not extracted from: \(json)"
        }
    }
}
