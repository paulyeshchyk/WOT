//
//  WOTWebResponseAdapterNested.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias JSONMappingCompletion = ([JSONMappingNestedRequest]?) -> Void


@objc
public class JSONMappingNestedRequest: NSObject {
    
    @objc
    public var clazz: AnyClass

    @objc
    public var identifier: AnyObject?

    @objc
    public var completion: (JSON) -> Void
    
    public init(clazz clazzTo: AnyClass, identifier id: AnyObject?, completion block: @escaping (JSON) -> Void) {
        clazz = clazzTo
        identifier = id
        completion = block
        super.init()
    }
}
