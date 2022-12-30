//
//  NSManagedObject+JSONDecodingProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import CoreData

public extension JSONDecodingProtocol where Self: NSManagedObject {
    func decode(decoderContainer: DecoderContainer) throws {
        try decodeWith(decoderContainer.decoder())
    }
}
