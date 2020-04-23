//
//  PrimaryKeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol PrimaryKeypathProtocol: class {
    static func primaryKeyPath() -> String?
    static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey?
    static func predicate(for ident: AnyObject?) -> NSPredicate?
}
