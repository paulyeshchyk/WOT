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
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    typealias OnComplete = (RequestProtocol?, Error?) -> Void

    var responseClass: AnyClass { get }
    var completion: ResponseAdapterProtocol.OnComplete? { get set }
    var modelClass: ModelClassType? { get set }
    var request: RequestProtocol? { get set }
    var socket: JointSocketProtocol? { get set }
    var extractorType: ManagedObjectExtractable.Type? { get set }

    init(appContext: Context)

    func decode(data: Data?)
}

// MARK: - JSONAdapterProtocol

public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {}
