//
//  JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

public protocol JSONMapperProtocol {
    associatedtype Fields
    func mapping(from jSON: Any)
}

