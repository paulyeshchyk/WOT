//
//  WOTWebResponseAdapterModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONResponseAdapterModules: WOTJSONResponseAdapter {
//
    override public var Clazz: PrimaryKeypathProtocol.Type { return Module.self }
}
