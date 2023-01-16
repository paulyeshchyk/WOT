//
//  JSONRef.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - JSONRefProtocol

public protocol JSONRefProtocol {
    var jsonCollection: JSONCollectionProtocol { get }
    var modelClass: PrimaryKeypathProtocol.Type { get }
}

// MARK: - JSONRef

public class JSONRef: JSONRefProtocol {

    public var jsonCollection: JSONCollectionProtocol
    public var modelClass: PrimaryKeypathProtocol.Type

    public init(jsonCollection: JSONCollectionProtocol?, modelClass: PrimaryKeypathProtocol.Type) throws {
        guard let jsonCollection = jsonCollection else {
            throw Errors.jsonIsNil
        }
        self.jsonCollection = jsonCollection
        self.modelClass = modelClass
    }

    public convenience init(element: JSON, modelClass: PrimaryKeypathProtocol.Type) throws {
        let collection = try JSONCollection(element: element)
        try self.init(jsonCollection: collection, modelClass: modelClass)
    }

    public convenience init(array: [JSON], modelClass: PrimaryKeypathProtocol.Type) throws {
        let collection = try JSONCollection(array: array)
        try self.init(jsonCollection: collection, modelClass: modelClass)
    }

    public convenience init(custom: Any, modelClass: PrimaryKeypathProtocol.Type) throws {
        let collection = JSONCollection(custom: custom)
        try self.init(jsonCollection: collection, modelClass: modelClass)
    }
}

// MARK: - %t + JSONRef.Errors

extension JSONRef {
    private enum Errors: Error, CustomStringConvertible {
        case jsonIsNil

        public var description: String {
            switch self {
            case .jsonIsNil: return "[\(type(of: self))]: json is nil"
            }
        }
    }
}
