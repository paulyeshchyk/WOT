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

@objc
public class JSONMappingNestedRequest: NSObject {
    
    public var clazz: AnyClass
    public var identifier: Any?
    public var completion: (JSON) -> Void
    
    init(clazz clazzTo: AnyClass, identifier id: Any?, completion block: @escaping (JSON) -> Void) {
        clazz = clazzTo
        identifier = id
        completion = block
        super.init()
    }
}


public typealias JSONMappingCompletion = ([JSONMappingNestedRequest]?) -> Void

public protocol JSONMapperProtocol {
    associatedtype Fields
    func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingCompletion?)
    func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingCompletion?)
}

extension NSManagedObject {
}
