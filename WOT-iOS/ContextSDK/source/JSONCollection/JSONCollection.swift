//
//  JSONCollection.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - JSONCollection

public class JSONCollection: JSONCollectionProtocol, CustomStringConvertible {

    public var description: String {
        return "[\(type(of: self))] collection: \(String(describing: collection))"
    }

    private var collectionType: JSONCollectionType

    private var collection = [JSON]()
    private var custom: Any?

    // MARK: Lifecycle

    public init(element: JSON) throws {
        collectionType = .element
        collection.append(element)
    }

    public init(array: [JSON]) throws {
        collectionType = .array
        try add(array: array)
    }

    public init(custom: Any?) {
        collectionType = .custom
        self.custom = custom
    }

    // MARK: Private

    private func add(element object: JSON?) throws {
        guard collectionType == .array else {
            throw JSONCollectionError.notAbleToAddElement(collectionType)
        }
        guard let element = object else {
            throw JSONCollectionError.notAbleToAddNilElement
        }
        collection.append(element)
    }

    private func add(array: [JSON]?) throws {
        guard collectionType == .array else {
            throw JSONCollectionError.notAbleToAddElement(collectionType)
        }
        guard let objects = array else {
            throw JSONCollectionError.nilArray
        }
        for object in objects {
            try add(element: object)
        }
    }

    public func data() -> Any? {
        switch collectionType {
        case .array: return collection
        case .element: return collection.first
        case .custom: return custom
        }
    }
}

// MARK: - JSONCollection + DecoderContainerProtocol

extension JSONCollection: DecoderContainerProtocol {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

// MARK: - JSONCollectionError

private enum JSONCollectionError: Error, CustomStringConvertible {
    case doesnotConformsToJSON(Any?)
    case nilArray
    case nilElement
    case notAbleToAddElement(JSONCollectionType)
    case notAbleToGetElement(JSONCollectionType)
    case notAbleToAddNilElement
    case cantUseCustomAsArray

    var description: String {
        switch self {
        case .cantUseCustomAsArray: return "[\(type(of: self))]: Custom type can't be used as colletion"
        case .doesnotConformsToJSON(let object): return "[\(type(of: self))]: \((object != nil) ? String(describing: object) : "nil object") does not conforms to JSON type"
        case .nilArray: return "[\(type(of: self))]: Array is nil"
        case .nilElement: return "[\(type(of: self))]: Element is nil"
        case .notAbleToAddElement(let collectionType): return "[\(type(of: self))]: Not able to add element because collectiontype is not collection, but \(collectionType)"
        case .notAbleToGetElement(let collectionType): return "[\(type(of: self))]: Not able to get element because collectiontype is not collection, but \(collectionType)"
        case .notAbleToAddNilElement: return "[\(type(of: self))]: Not able to add nil element"
        }
    }
}
