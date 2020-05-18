//
//  WOTRequestArgumentsProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc public protocol WOTRequestArgumentsProtocol {
    init(_ dictionary: JSON)
    func setValues(_ values: Any, forKey: AnyHashable)
    func buildQuery(_ custom: JSON) -> String
}
