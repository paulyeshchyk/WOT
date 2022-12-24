//
//  VehicleprofileTurret+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension VehicleprofileTurret {
    public override func mapping(jsonmap: JSONMapManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //
        try self.decode(json: jsonmap.json)
        //
    }
}
