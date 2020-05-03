//
//  WOTStartableProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTStartableProtocol {
    func cancel(with error: Error?)
    func start(withArguments: WOTRequestArgumentsProtocol) throws
}
