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

    var responseClass: AnyClass { get }

    init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, managedObjectCreator: ManagedObjectLinkerProtocol, appContext: Context)

    func decode(data: Data?, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?)
}

public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {}
