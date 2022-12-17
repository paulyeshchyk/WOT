//
//  VehicleprofileAmmoDamage+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmoDamage {
     override public func mapping(array: [Any], managedObjectContext: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: WOTRequestManagerProtocol) throws {
        //
        guard array.count == 3 else {
            throw ErrorVehicleprofileAmmoDamage.arrayIsNotContainingThreeElements
        }
        let intArray = NSDecimalNumberArray(array: array)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}
