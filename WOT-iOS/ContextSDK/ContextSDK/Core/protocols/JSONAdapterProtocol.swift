//
//  JSONAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol
    
    var linker: JSONAdapterLinkerProtocol { get set }
    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: Context, jsonAdapterLinker: JSONAdapterLinkerProtocol)
}
