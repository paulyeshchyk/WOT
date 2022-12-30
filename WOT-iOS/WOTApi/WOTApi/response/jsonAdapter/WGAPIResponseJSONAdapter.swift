//
//  WGResponseJSONAdapter.swift
//  WOTApi
//
//  Created by Paul on 27.12.22.
//

import ContextSDK

public class WGAPIResponseJSONAdapter: JSONAdapter {
    //

    override public var responseClass: AnyClass {
        return WGAPIResponse.self
    }

    public override func decodedObject(jsonDecoder: JSONDecoder, from: Data) throws -> JSON? {
        let result = try jsonDecoder.decode(WGAPIResponse.self, from: from)
        if let swiftError = result.swiftError {
            throw swiftError
        }
        return result.data
    }
}
