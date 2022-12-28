//
//  VehicleprofileGunJSONAdapter.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

class VehicleprofileGunJSONAdapter: WGResponseJSONAdapter {
    //
    override func performJSONExtraction(from json: JSON, byKey key: AnyHashable) throws -> JSON {
        guard let jsonByKey = json[key] as? JSON else {
            throw WGResponseJSONAdapter.WGResponseJSONAdapterError.jsonByKeyWasNotFound(json, key)
        }
        let innerKey = #keyPath(Vehicleprofile.gun)
        guard let result = jsonByKey[innerKey] as? JSON else {
            throw WGResponseJSONAdapter.WGResponseJSONAdapterError.jsonByKeyWasNotFound(jsonByKey, innerKey)
        }
        return result
    }
}
