//
//  SessionManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol SessionManagerContainerProtocol {
    @objc var sessionManager: SessionManagerProtocol? { get set }
}

@objc
public protocol SessionManagerProtocol {
    func login()
    func logout()
}

