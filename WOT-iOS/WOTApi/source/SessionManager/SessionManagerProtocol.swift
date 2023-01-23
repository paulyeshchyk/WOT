//
//  SessionManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - SessionManagerContainerProtocol

@objc
public protocol SessionManagerContainerProtocol {
    var sessionManager: SessionManagerProtocol? { get set }
}

// MARK: - SessionManagerProtocol

@objc
public protocol SessionManagerProtocol {
    func login()
    func logout()
}
