//
//  PrimaryKeypathProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public enum PrimaryKeyType: Int {
    case `internal`
    case external
}

@objc
public protocol PrimaryKeypathProtocol: class {
    static func predicateFormat(forType: PrimaryKeyType) -> String
    static func predicate(for ident: AnyObject?, andType: PrimaryKeyType) -> NSPredicate?
    static func primaryKeyPath(forType: PrimaryKeyType) -> String
    static func primaryKey(for ident: Any, andType: PrimaryKeyType) -> WOTPrimaryKey?
}
