//
//  WebLayer.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

struct WebLayer {
    
}

public protocol JSONMapperProtocol {
    associatedtype Fields
    func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingCompletion?)
    func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingCompletion?)
}
