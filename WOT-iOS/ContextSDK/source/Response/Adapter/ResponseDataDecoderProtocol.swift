//
//  ResponseDataDecoderProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - ResponseDataDecoderProtocol

@objc
public protocol ResponseDataDecoderProtocol {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestRegistratorContainerProtocol
        & RequestManagerContainerProtocol
        & DecoderManagerContainerProtocol

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    typealias OnComplete = (RequestProtocol, JSON?, Error?) -> Void

    var completion: ResponseDataDecoderProtocol.OnComplete? { get set }
    var request: RequestProtocol? { get set }

    init(appContext: Context)

    func decode(data: Data?, fromRequest request: RequestProtocol)
}

// MARK: - JSONDataDecoderProtocol

public protocol JSONDataDecoderProtocol: ResponseDataDecoderProtocol, MD5Protocol {}
