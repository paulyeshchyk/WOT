//
//  VehicleprofileArmorList+Fetchable.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileArmorList: FetchableProtocol {

    public class func dataFieldsKeypaths() -> [String] {
        return []
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
