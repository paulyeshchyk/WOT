//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol ResponseAdapterProtocol {

    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol

    typealias OnComplete = (RequestProtocol, Error?) -> Void
    
    init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: Context, adapterLinker: ManagedObjectCreatorProtocol)
    
    func decodeData(_ data: Data?, forType: AnyClass, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?)
}
