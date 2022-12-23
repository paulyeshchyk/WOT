//
//  JSONAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias JSON = Swift.Dictionary<Swift.AnyHashable, Any>

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol, MD5Protocol {
    
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol
    
    var linker: JSONAdapterLinkerProtocol { get set }

    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: Context, jsonAdapterLinker: JSONAdapterLinkerProtocol)
}
