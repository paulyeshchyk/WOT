//
//  UserSession+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONDecodingProtocol

extension UserSession: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {}
}
