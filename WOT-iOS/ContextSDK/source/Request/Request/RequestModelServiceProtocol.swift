//
//  RequestModelServiceProtocol.swift
//  ContextSDK
//
//  Created by Paul on 27.12.22.
//

@objc
public protocol RequestModelServiceProtocol: AnyObject {
    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    static func registrationID() -> RequestIdType
    static func modelClass() -> ModelClassType?
    static func responseDataDecoderClass() -> ResponseDataDecoderProtocol.Type
}
