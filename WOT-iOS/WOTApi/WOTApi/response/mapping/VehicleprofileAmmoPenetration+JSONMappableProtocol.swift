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
    private enum VehicleprofileAmmoPenetrationError: Error, CustomStringConvertible {
        case arrayIsExpected(Any)
        case arrayIsNotContainingThreeElements([Any])
        var description: String {
            switch self {
            case .arrayIsExpected(let object): return "[\(type(of: self))]: Array is expected, but \(type(of: object))"
            case .arrayIsNotContainingThreeElements(let array): return "[\(type(of: self))]: Array is not containing 3 elements, but \(array.count)"
            }
        }
    }

    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let penetration = map.mappingData as? [Any] else {
            throw VehicleprofileAmmoPenetrationError.arrayIsExpected(map.mappingData ?? NSNull())
        }

        //
        guard penetration.count == 3 else {
            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements(penetration)
        }
        let intArray = NSDecimalNumberArray(array: penetration)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}
