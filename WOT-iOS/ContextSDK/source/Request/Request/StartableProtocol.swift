//
//  WOTStartableProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestCancelReasonProtocol

@objc
public protocol RequestCancelReasonProtocol {
    var reasonDescription: String { get }
    var error: Error? { get }
}

// MARK: - ResponseCancelReasonProtocol

@objc
public protocol ResponseCancelReasonProtocol {
    var reasonDescription: String { get }
    var error: Error? { get }
}

// MARK: - StartableProtocol

@objc
public protocol StartableProtocol {
    func cancel(byReason: RequestCancelReasonProtocol) throws
    func start() throws
}
