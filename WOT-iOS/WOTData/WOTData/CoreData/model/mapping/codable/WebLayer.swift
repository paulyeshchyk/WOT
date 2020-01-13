//
//  WebLayer.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

struct WebLayer {
    
}


public protocol JSONMapperProtocol {
    associatedtype Fields
    func mapping(from jSON: Any)
}

