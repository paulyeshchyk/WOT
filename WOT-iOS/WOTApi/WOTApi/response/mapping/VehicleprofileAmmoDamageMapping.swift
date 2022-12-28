//
//  VehicleprofileAmmoDamage+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoDamage {
    // MARK: - JSONMappableProtocol

    override public func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONMappableProtocol.Context) throws {
        guard let ammoDamageJSON = map.mappingData as? [Any] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }
        //
        guard ammoDamageJSON.count == 3 else {
            throw VehicleprofileAmmoDamageError.arrayIsNotContainingThreeElements
        }
        let intArray = NSDecimalNumberArray(array: ammoDamageJSON)
        self.min_value = intArray.elements[0]
        self.avg_value = intArray.elements[1]
        self.max_value = intArray.elements[2]
    }
}

private enum VehicleprofileAmmoDamageError: Error, CustomStringConvertible {
    case arrayIsNotContainingThreeElements
    var description: String {
        switch self {
        case .arrayIsNotContainingThreeElements: return "[\(type(of: self))]: Dublicate"
        }
    }
}
