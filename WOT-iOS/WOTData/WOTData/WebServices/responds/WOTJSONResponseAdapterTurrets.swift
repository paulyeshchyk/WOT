//
//  WOTWebResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONResponseAdapterTurrets: WOTJSONResponseAdapter {
//
    override public var Clazz: PrimaryKeypathProtocol.Type { return VehicleprofileTurret.self }
}
