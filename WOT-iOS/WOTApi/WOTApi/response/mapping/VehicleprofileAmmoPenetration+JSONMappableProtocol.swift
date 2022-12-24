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
    private enum VehicleprofileAmmoPenetrationError: Error {
        case arrayIsNotContainingThreeElements
    }
    public override func mapping(arraymap: ArrayManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //
        guard arraymap.array.count == 3 else {
            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements
        }
        let intArray = NSDecimalNumberArray(array: arraymap.array)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}
