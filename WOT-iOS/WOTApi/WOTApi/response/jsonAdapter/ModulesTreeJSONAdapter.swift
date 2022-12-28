//
//  ModulesTreeJSONAdapter.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

class ModulesTreeJSONAdapter: WGResponseJSONAdapter {
    //
    override func performJSONExtraction(from json: JSON, byKey key: AnyHashable) throws -> JSON {
        guard let jsonByKey = json[key] as? JSON else {
            throw WGResponseJSONAdapter.WGResponseJSONAdapterError.jsonByKeyWasNotFound(json, key)
        }
        return jsonByKey
    }
}
