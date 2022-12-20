//
//  WOTStartableProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol StartableProtocol {
    func cancel(with error: Error?)
    func start(withArguments: RequestArgumentsProtocol) throws
}
