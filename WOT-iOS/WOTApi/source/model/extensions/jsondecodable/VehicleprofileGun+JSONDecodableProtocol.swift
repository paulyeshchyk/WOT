//
//  VehicleprofileGun+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileGun {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, fetchResult _: ManagedObjectContextContainerProtocol, appContext _: JSONDecodableProtocol.Context?) throws {
        //
        let gunJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: gunJSON)
        //
    }
}
