//
//  RequestableProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol RequestableProtocol: AnyObject {
    static func dataFieldsKeypaths() -> [String]
    static func relationFieldsKeypaths() -> [String]
    static func fieldsKeypaths() -> [String]
}
