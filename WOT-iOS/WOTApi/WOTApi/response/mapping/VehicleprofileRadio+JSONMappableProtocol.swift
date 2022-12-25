//
//  VehicleprofileRadio+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileRadio {
    override public func mapping(jsonmap: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //
        try self.decode(decoderContainer: jsonmap.json)
        //
    }
}
