//
//  VehicleprofileArmor+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileArmor {
    // MARK: - JSONMappableProtocol

    override public func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONMappableProtocol.Context) throws {
        guard let armorJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: armorJSON)
        //
    }
}
