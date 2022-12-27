//
//  JSONAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias JSON = Swift.Dictionary<Swift.AnyHashable, Any>

@objc
public protocol JSONCollectable {
    func add(element: JSON?) throws
    func add(array: [JSON]?) throws
    func data() -> Any?
    
    subscript(index: Int) -> JSON? { get }
    
}

public class JSONCollection: JSONCollectable {
    public  enum CollectionType: Int, CustomStringConvertible {
        case element
        case array
        case custom
        public var description: String {
            switch self {
            case .element: return "element"
            case .array: return "array"
            case .custom: return "custom"
            }
        }
    }

    private enum JSONCollectionError: Error, CustomStringConvertible {
        case doesnotConformsToJSON(Any?)
        case nilArray
        case nilElement
        case notAbleToAddElement(JSONCollection.CollectionType)
        case notAbleToGetElement(JSONCollection.CollectionType)
        case notAbleToAddNilElement
        var description: String {
            switch self {
            case .doesnotConformsToJSON(let object): return "[\(type(of: self))]: \((object != nil) ? String(describing: object) : "nil object") does not conforms to JSON type"
            case .nilArray: return "[\(type(of: self))]: Array is nil"
            case .nilElement: return "[\(type(of: self))]: Element is nil"
            case .notAbleToAddElement(let collectionType): return "[\(type(of: self))]: Not able to add element because collectiontype is not collection, but \(collectionType)"
            case .notAbleToGetElement(let collectionType): return "[\(type(of: self))]: Not able to get element because collectiontype is not collection, but \(collectionType)"
            case .notAbleToAddNilElement: return "[\(type(of: self))]: Not able to add nil element"
            }
        }
    }
    
    private var collection = [JSON]()
    private var custom: Any?
    public private(set) var collectionType: JSONCollection.CollectionType
    
    public init?(element object: JSON?) throws {
        self.collectionType = .element
        guard let element = object  else {
            throw JSONCollectionError.nilElement
        }
        
        collection.append(element)
    }

    public init?(array: [JSON]?) throws {
        self.collectionType = .array
        try add(array: array)
    }
    
    public init?(custom: Any?) {
        self.collectionType = .custom
        self.custom = custom
    }
    
    public subscript(index: Int) -> JSON? {
        #warning("add throw for collectiontype==custom")
        return self.collection[index]
    }
    
    public func add(element object: JSON?) throws {
        guard collectionType == .array else {
            throw JSONCollectionError.notAbleToAddElement(collectionType)
        }
        guard let element = object else {
            throw JSONCollectionError.notAbleToAddNilElement
        }
        collection.append(element)
    }
    
    public func add(array: [JSON]?) throws {
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

extension JSONCollection: DecoderContainer {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

@objc
public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {
    
}
