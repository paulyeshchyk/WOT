//
//  NSManagedObject+JSONMappableProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

// MARK: - NSManagedObject + JSONDecoderProtocol

extension NSManagedObject: JSONDecoderProtocol {

    public enum DataFieldsKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = DataFieldsKeys

    @objc
    open func decode(using _: JSONMapProtocol, appContext _: JSONDecoderProtocol.Context?, forDepthLevel _: DecodingDepthLevel?) throws {
        throw NSManagedObjectJSONMappableError.hasNotBeenImplemented("\(type(of: self))::\(#function)")
    }
}

// MARK: - NSManagedObjectJSONMappableError

private enum NSManagedObjectJSONMappableError: Error, CustomStringConvertible {
    case hasNotBeenImplemented(String)

    var description: String {
        switch self {
        case .hasNotBeenImplemented(let text): return "\(type(of: self)): '\(text)' has not been implemented"
        }
    }
}
