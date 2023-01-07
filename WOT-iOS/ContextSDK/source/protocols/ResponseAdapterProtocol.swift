//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - ResponseAdapterProtocol

@objc
public protocol ResponseAdapterProtocol {
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol

    typealias OnComplete = (RequestProtocol, Error?) -> Void

    var responseClass: AnyClass { get }

    init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, managedObjectLinker: ManagedObjectLinkerProtocol, jsonExtractor: ManagedObjectExtractable, appContext: Context)

    func decode(data: Data?, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?)
}

// MARK: - JSONAdapterProtocol

public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {}