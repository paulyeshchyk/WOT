//
//  VehicleprofileArmor+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileArmor {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, appContext: JSONDecoderProtocol.Context?, forDepthLevel: DecodingDepthLevel?) throws {
        let decoder = VehicleprofileArmorJSONDecoder()
        decoder.managedObject = self
        try decoder.decode(using: map, appContext: appContext, forDepthLevel: forDepthLevel)
    }
}
