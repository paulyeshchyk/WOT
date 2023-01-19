//
//  JSONCollection.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - JSONCollection

public class JSONCollection: JSONCollectionProtocol, CustomStringConvertible {

    public var description: String {
        let collectionDescription: String
        switch collectionType {
        case .custom: collectionDescription = String(describing: custom, orValue: "<NULL>")
        default: collectionDescription = String(describing: collection, orValue: "<NULL>")
        }
        return "[\(type(of: self))] collectionType: \(String(describing: collectionType)), collection: \(collectionDescription)"
    }

    private var collectionType: JSONCollectionType
    private var collection: [JSON]?
    private var custom: Any?

    // MARK: Lifecycle

    public init(data: Any?) {
        if let jsonArray = data as? [JSON] {
            collectionType = .array
            collection = [JSON]()
            collection?.append(contentsOf: jsonArray)
        } else if let jsonElement = data as? JSON {
            collectionType = .element
            collection = [JSON]()
            collection?.append(jsonElement)
        } else {
            collectionType = .custom
            collection = nil
            custom = data
        }
    }

    public func data() -> Any? {
        switch collectionType {
        case .array: return collection
        case .element: return collection?.first
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
