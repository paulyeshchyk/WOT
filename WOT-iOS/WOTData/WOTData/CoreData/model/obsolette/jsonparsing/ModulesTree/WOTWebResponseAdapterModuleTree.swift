//
//  WOTWebResponseAdapterModuleTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTWebResponseAdapterModuleTree: NSObject, WOTWebResponseAdapter {
    public func parseData(_ binary: Data?, error: Error?, nestedRequestsCallback: JSONMappingCompletion?) -> Error? {
        return (binary as? NSData)?.parseAsJSON { (_) in
        }
    }
}
