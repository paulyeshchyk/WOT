//
//  ModelServiceProtocol.swift
//  ContextSDK
//
//  Created by Paul on 27.12.22.
//

@objc
public protocol ModelServiceProtocol: AnyObject {
    static func modelClass() -> PrimaryKeypathProtocol.Type?
    static func registrationID() -> RequestIdType
    func instanceModelClass() -> AnyClass?
}
