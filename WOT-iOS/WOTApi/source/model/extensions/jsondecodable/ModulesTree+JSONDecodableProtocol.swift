//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension ModulesTree {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, appContext: JSONDecoderProtocol.Context?, forDepthLevel: DecodingDepthLevel?) throws {
        let decoder = ModulesTreeJSONDecoder()
        decoder.managedObject = self
        try decoder.decode(using: map, appContext: appContext, forDepthLevel: forDepthLevel)
    }
}
