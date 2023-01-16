//
//  JSONRef.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - JSONRefProtocol

@objc
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

    public convenience init(element: JSON?, modelClass: PrimaryKeypathProtocol.Type) throws {
        guard let element = element else { throw Errors.jsonIsNil }
        let collection = try JSONCollection(element: element)
        try self.init(jsonCollection: collection, modelClass: modelClass)
    }

    public convenience init(array: [JSON]?, modelClass: PrimaryKeypathProtocol.Type) throws {
        guard let array = array else { throw Errors.arrayIsNil }
        let collection = try JSONCollection(array: array)
        try self.init(jsonCollection: collection, modelClass: modelClass)
    }

    public convenience init(custom: Any?, modelClass: PrimaryKeypathProtocol.Type) throws {
        guard let custom = custom else { throw Errors.customIsNil }
        let collection = JSONCollection(custom: custom)
        try self.init(jsonCollection: collection, modelClass: modelClass)
    }
}

// MARK: - %t + JSONRef.Errors

extension JSONRef {
    private enum Errors: Error, CustomStringConvertible {
        case jsonIsNil
        case arrayIsNil
        case customIsNil

        public var description: String {
            switch self {
            case .jsonIsNil: return "[\(type(of: self))]: json is nil"
            case .arrayIsNil: return "[\(type(of: self))]: array is nil"
            case .customIsNil: return "[\(type(of: self))]: custom is nil"
            }
        }
    }
}
