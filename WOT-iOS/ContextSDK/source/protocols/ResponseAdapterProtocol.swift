//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - ResponseAdapterProtocol

@objc
public protocol ResponseAdapterProtocol {

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestManagerContainerProtocol

    typealias OnComplete = (RequestProtocol, Error?) -> Void

    var responseClass: AnyClass { get }
    var completion: ResponseAdapterProtocol.OnComplete? { get set }
    var modelClass: PrimaryKeypathProtocol.Type { get }
    var request: RequestProtocol? { get set }
    var linker: ManagedObjectLinkerProtocol? { get set }
    var extractor: ManagedObjectExtractable? { get set }

    init(appContext: Context, modelClass: PrimaryKeypathProtocol.Type)

    func decode(data: Data?, fromRequest request: RequestProtocol)
}

// MARK: - JSONAdapterProtocol

public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {}
