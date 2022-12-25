//
//  JSONAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias JSON = Swift.Dictionary<Swift.AnyHashable, Any>

public protocol JSONCollectable {
    func add(_ object: Any) throws
    func add(_ objects: [Any]) throws
    subscript(index: Int) -> JSON? { get }
}

public class JSONCollection: JSONCollectable {

    private enum JSONCollectionError: Error {
        case doesnotConformsToJSON(Any)
        var description: String {
            switch self {
            case .doesnotConformsToJSON(let object): return "\(type(of: object)) does not conforms to JSON type"
            }
        }
    }
    
    private var collection = [JSON]()
    public subscript(index: Int) -> JSON? {
        collection[index]
    }
    
    public func add(_ object: Any) throws {
        guard let element = object as? JSON else {
            throw JSONCollectionError.doesnotConformsToJSON(object)
        }
        collection.append(element)
    }
    public func add(_ objects: [Any]) throws {
        for object in objects {
            try add(object)
        }
    }
}

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol, MD5Protocol {
    
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol
    
    var linker: JSONAdapterLinkerProtocol { get set }

    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: Context, jsonAdapterLinker: JSONAdapterLinkerProtocol)
}
