//
//  JSONDecodingProtocol.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

import CoreData

public protocol JSONDecodingProtocol {
    func decodeWith(_ decoder: Decoder) throws
}

extension JSONDecodingProtocol where Self: NSManagedObject {
    public func decode(decoderContainer: DecoderContainer) throws {
        try decodeWith(decoderContainer.decoder())
    }
}
