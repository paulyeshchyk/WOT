//
//  WOTWebResponseAdapterNested.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTJSONLinksCallback = ([WOTJSONLink]?) -> Void

@objc
public class WOTJSONLink: NSObject {
    
    @objc
    public var clazz: AnyClass

    @objc
    public var identifier: String?
    
    @objc
    public var identifier_fieldname: String?

    @objc
    public var completion: (JSON) -> Void
    
    public init(clazz clazzTo: AnyClass, identifier_fieldname id_fieldname: String, identifier id: String?, completion block: @escaping (JSON) -> Void) {
        clazz = clazzTo
        identifier = id
        identifier_fieldname = id_fieldname
        completion = block
        super.init()
    }
}
