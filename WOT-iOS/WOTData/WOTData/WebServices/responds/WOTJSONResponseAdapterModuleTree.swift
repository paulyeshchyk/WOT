//
//  WOTWebResponseAdapterModuleTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONResponseAdapterModuleTree: WOTJSONResponseAdapter {
//
    override public var Clazz: PrimaryKeypathProtocol.Type { return ModulesTree.self }
}
