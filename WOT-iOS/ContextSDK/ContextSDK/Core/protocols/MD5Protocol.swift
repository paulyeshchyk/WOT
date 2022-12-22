//
//  MD5Protocol.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

@objc
public protocol MD5Protocol {
    @objc
    var MD5: String? { get }

    var uuid: UUID { get }
}

func == (lhs: MD5Protocol, rhs: MD5Protocol) -> Bool {
    return lhs.MD5 == rhs.MD5
}


@objc
public protocol DescriptableProtocol {
    @objc
    var description: String { get }
}
