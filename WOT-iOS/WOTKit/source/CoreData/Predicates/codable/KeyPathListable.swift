//
//  KeyPathListable.swift
//
//  Created by porterchild
//
//  https://forums.swift.org/t/getting-keypaths-to-members-automatically-using-mirror/21207
//

import Foundation

protocol KeyPathListable {
    associatedtype AnyOldObject
    // require empty init as the implementation use the mirroring API, which require
    // to be used on an instance. So we need to be able to create a new instance of the
    // type. See @@@^^^@@@
    init()

    var keyPathReadableFormat: [String: Any] { get }
    var allKeyPaths: [String: KeyPath<AnyOldObject, Any?>] { get }
}

extension KeyPathListable {
    var keyPathReadableFormat: [String: Any] {
        var description: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            description[label] = value
        }
        return description
    }

    var allKeyPaths: [String: KeyPath<Self, Any?>] {
        var membersTokeyPaths: [String: KeyPath<Self, Any?>] = [:]
        let instance = Self() // @@@^^^@@@
        for (key, _) in instance.keyPathReadableFormat {
            membersTokeyPaths[key] = \Self.keyPathReadableFormat[key]
        }
        return membersTokeyPaths
    }
}

@objc
public protocol KeypathProtocol: class {
    static func fieldsKeypaths() -> [String]
    static func relationsKeypaths() -> [String]
    static func classKeypaths() -> [String]
}
