//
//  DescribableProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/28/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc public protocol Describable {
    var description: String { get }
}

@available(*, deprecated, message: "Use Describable instead")
@objc public protocol ObjCDescribable {
    @objc
    var description: String { get }
}
