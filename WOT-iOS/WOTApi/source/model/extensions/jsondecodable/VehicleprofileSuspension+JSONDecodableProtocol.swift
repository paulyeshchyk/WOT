//
//  VehicleprofileSuspension+JSONMappingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileSuspension {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer _: ManagedObjectContextContainerProtocol, appContext _: JSONDecodableProtocol.Context?) throws {
        //
        let suspensionJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: suspensionJSON)
        //
    }
}
