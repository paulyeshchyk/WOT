//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - ResponseAdapterProtocol

@objc
public protocol ResponseAdapterProtocol {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestRegistratorContainerProtocol
        & RequestManagerContainerProtocol
        & DecoderManagerContainerProtocol

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    typealias OnComplete = (RequestProtocol, Error?) -> Void

    var responseClass: AnyClass { get }
    var completion: ResponseAdapterProtocol.OnComplete? { get set }
    var modelClass: ModelClassType { get }
    var request: RequestProtocol? { get set }
    var socket: JointSocketProtocol? { get set }
    var extractor: ManagedObjectExtractable? { get set }

    init(appContext: Context, modelClass: ModelClassType)

    func decode(data: Data?, fromRequest request: RequestProtocol)
}

// MARK: - JSONAdapterProtocol

public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {}
