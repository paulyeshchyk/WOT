//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

public typealias JSON = [AnyHashable: Any]


//TODO: transform an conforming class to Future/Promise

@objc
public protocol WOTWebResponseAdapter: NSObjectProtocol {
    @discardableResult
    func parseData(_ data: Data?, error: Error?, nestedRequestsCallback: JSONMappingCompletion?) -> Error?
}
