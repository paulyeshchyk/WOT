//
//  JSONMapperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol JSONMapperProtocol {
    associatedtype Fields

    mutating func mapping(fromJSON jSON: JSON)
    func mapping(fromArray array: [Any])

    func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?)
    func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?)
}

extension JSONMapperProtocol {
    public func mapping(fromJSON jSON: JSON) {}
    public func mapping(fromArray array: [Any]) {}
    public func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {}
    public func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {}
}
