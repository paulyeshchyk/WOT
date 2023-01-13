//
//  NSManagedObject+JSONDecodingProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import CoreData

public extension JSONDecodingProtocol where Self: NSManagedObject {

    func decode(decoderContainer: DecoderContainer?) throws {
        guard let decoderContainer = decoderContainer else {
            throw JSONDecodingError.containerIsNil
        }
        try decodeWith(decoderContainer.decoder())
    }
}

// MARK: - JSONDecodingError

private enum JSONDecodingError: Error, CustomStringConvertible {
    case containerIsNil

    public var description: String {
        switch self {
        case .containerIsNil: return "[\(type(of: self))]: Container is nil"
        }
    }
}
