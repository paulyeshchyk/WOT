//
//  MD5Protocol.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

@objc
public protocol MD5Protocol {
    @objc
    var MD5: String { get }

    @objc
    var uuid: UUID { get }
}
