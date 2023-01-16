//
//  VehicleprofileRadio+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileRadio {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, appContext _: JSONDecodableProtocol.Context?) throws {
        //
        let radioJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: radioJSON)
        //
    }
}
