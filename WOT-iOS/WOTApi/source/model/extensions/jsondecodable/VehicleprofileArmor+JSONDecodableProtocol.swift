//
//  VehicleprofileArmor+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileArmor {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, fetchResult _: ManagedObjectContextContainerProtocol, appContext _: JSONDecodableProtocol.Context?) throws {
        //
        let armorJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: armorJSON)
        //
    }
}
