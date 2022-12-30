//
//  VehicleprofileAmmoPenetration+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoPenetration {
    // MARK: - JSONDecodableProtocol

    override public func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let penetrationJSON = map.mappingData as? [Any] else {
            throw VehicleprofileAmmoPenetrationError.arrayIsExpected(map.mappingData ?? NSNull())
        }
        //
        guard penetrationJSON.count == 3 else {
            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements(penetrationJSON)
        }
        let intArray = NSDecimalNumberArray(array: penetrationJSON)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}

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
