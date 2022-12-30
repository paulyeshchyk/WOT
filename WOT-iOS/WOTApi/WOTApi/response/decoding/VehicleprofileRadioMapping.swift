//
//  VehicleprofileRadio+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileRadio {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONManagedObjectMapProtocol, appContext _: JSONDecodableProtocol.Context) throws {
        guard let radioJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: radioJSON)
        //
    }
}
