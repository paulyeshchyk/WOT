//
//  RequestableProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol RequestableProtocol: AnyObject {
    static func fieldsKeypaths() -> [String]
    static func relationsKeypaths() -> [String]
    static func classKeypaths() -> [String]
}
