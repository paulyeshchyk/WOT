//
//  WOTWebResponseAdapterModuleTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterModuleTree: WOTWebResponseAdapter {
    public override func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol) -> Error? {
        return binary?.parseAsJSON { (_) in
        }
    }
}
