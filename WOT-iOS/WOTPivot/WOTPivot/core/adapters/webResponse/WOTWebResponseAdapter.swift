//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

public typealias JSON = [AnyHashable: Any]

@objc
public protocol WOTWebResponseAdapter: NSObjectProtocol {
    func parseJSON(_ json: JSON, error: NSError?, nestedRequestsCallback: JSONMappingCompletion?)
}
