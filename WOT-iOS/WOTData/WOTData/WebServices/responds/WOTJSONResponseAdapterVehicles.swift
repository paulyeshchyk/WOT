//
//  WOTWebResponseAdapterVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONResponseAdapterVehicles: WOTJSONResponseAdapter {
//
    override public var Clazz: PrimaryKeypathProtocol.Type { return Vehicles.self }
}
