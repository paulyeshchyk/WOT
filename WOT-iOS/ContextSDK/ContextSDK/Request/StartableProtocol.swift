//
//  WOTStartableProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol RequestCancelReasonProtocol {
    var reasonDescription: String { get }
    var error: Error? { get }
}

@objc
public protocol StartableProtocol {
    func cancel(byReason: RequestCancelReasonProtocol) throws
    func start(withArguments: RequestArgumentsProtocol) throws
}
