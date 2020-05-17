//
//  VehicleprofileEngine+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileEngine {
    @objc
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?, fetcher: WOTFetcherProtocol?) throws {
        //
        try self.decode(json: json)
        //
    }
}
