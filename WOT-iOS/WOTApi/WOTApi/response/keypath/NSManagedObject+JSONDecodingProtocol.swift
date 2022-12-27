//
//  NSManagedObject+JSONDecodingProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import CoreData

extension JSONDecodingProtocol where Self: NSManagedObject {
    public func decode(decoderContainer: DecoderContainer) throws {
        try decodeWith(decoderContainer.decoder())
    }
}
