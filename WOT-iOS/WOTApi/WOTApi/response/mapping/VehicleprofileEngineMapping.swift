//
//  VehicleprofileEngine+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileEngine {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, appContext: JSONMappableProtocol.Context) throws {
        guard let engineJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: engineJSON)
        //
    }
}
