//
//  JSONDecodingProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol JSONDecodingProtocol {
    func decodeWith(_ decoder: Decoder) throws
}
