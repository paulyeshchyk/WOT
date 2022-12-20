//
//  VehicleprofileAmmoPenetration+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmoPenetration {
    public override func mapping(array: [Any], objectContext: ObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: RequestManagerProtocol) throws {
        //
        guard array.count == 3 else {
            throw ErrorVehicleprofileAmmoPenetration.arrayIsNotContainingThreeElements
        }
        let intArray = NSDecimalNumberArray(array: array)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}
