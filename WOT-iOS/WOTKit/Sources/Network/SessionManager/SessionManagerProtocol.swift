//
//  WOTWebSession.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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