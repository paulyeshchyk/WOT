//
//  VehicleprofileTurret+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileTurret {
    public override func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, linker: WOTLinkerProtocol?, fetcherAndDecoder: WOTFetchAndDecodeProtocol?, decoderAndMapper: WOTDecodeAndMappingProtocol) throws {
        //
        try self.decode(json: json)
        //
    }
}
