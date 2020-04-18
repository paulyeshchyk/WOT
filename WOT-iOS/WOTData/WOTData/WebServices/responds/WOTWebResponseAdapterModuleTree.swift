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
    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapter) -> Error? {
        return binary?.parseAsJSON { (_) in
        }
    }
}
