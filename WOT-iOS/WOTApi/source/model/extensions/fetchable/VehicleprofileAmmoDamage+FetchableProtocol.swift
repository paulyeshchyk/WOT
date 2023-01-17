//
//  VehicleprofileAmmoDamage+KeypathProtocol\.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - FetchableProtocol

extension VehicleprofileAmmoDamage: FetchableProtocol {

    public class func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    public class func relationFieldsKeypaths() -> [String] {
        return []
    }

    public class func fieldsKeypaths() -> [String] {
        let fields = dataFieldsKeypaths()
        let relations = relationFieldsKeypaths()
        return fields + relations
    }
}
