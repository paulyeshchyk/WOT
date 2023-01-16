//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicles {

    // MARK: - JSONDecodableProtocol

    override func decode(using jsonMap: JSONMapProtocol, appContext: JSONDecoderProtocol.Context?, forDepthLevel: DecodingDepthLevel?) throws {
        let decoder = VehiclesJSONDecoder()
        decoder.managedObject = self
        try decoder.decode(using: jsonMap, appContext: appContext, forDepthLevel: forDepthLevel)
    }
}
