//
//  RequestableProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol RequestableProtocol: class {
    static func fieldsKeypaths() -> [String]
    static func relationsKeypaths() -> [String]
    static func classKeypaths() -> [String]
}
