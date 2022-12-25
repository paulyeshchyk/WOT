//
//  VehicleprofileGun+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension VehicleprofileGun {
    override public func mapping(jsonmap: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //
        try self.decode(decoderContainer: jsonmap.json)
        //
    }
}
