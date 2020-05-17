//
//  VehicleprofileGun+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - JSONMappableProtocol

extension VehicleprofileGun {
    public override func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, fetcher: WOTFetcherProtocol?, linker: WOTLinkerProtocol?, fetcherAndDecoder: WOTFetchAndDecodeProtocol?, decoderAndMapper: WOTDecodeAndMappingProtocol) throws {
        //
        try self.decode(json: json)
        //
    }
}
