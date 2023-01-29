//
//  UOWProtocol.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWType

@objc
public enum UOWType: Int {
    case decodeAndLink
    case remote
}

// MARK: - UOWProtocol

@objc
public protocol UOWProtocol: MD5Protocol {
    var uowType: UOWType { get }
}
