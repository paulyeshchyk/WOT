//
//  ModelServiceProtocol.swift
//  ContextSDK
//
//  Created by Paul on 27.12.22.
//

@objc
public protocol ModelServiceProtocol: AnyObject {
    static func registrationID() -> RequestIdType
    static func modelClass() -> PrimaryKeypathProtocol.Type?
    static func responseParserClass() -> ResponseParserProtocol.Type
    static func dataAdapterClass() -> ResponseAdapterProtocol.Type
}
