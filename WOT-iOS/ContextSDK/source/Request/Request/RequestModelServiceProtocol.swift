//
//  RequestModelServiceProtocol.swift
//  ContextSDK
//
//  Created by Paul on 27.12.22.
//

@objc
public protocol RequestModelServiceProtocol: AnyObject {

    static func registrationID() -> RequestIdType
    static func modelClass() -> ModelClassType?
    static func dataAdapterClass() -> ResponseAdapterProtocol.Type
}
