//
//  WOTWebResponseAdapterAmmoList.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterAmmoList: WOTWebResponseAdapter {
    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol) -> Error? {
        return nil
    }

    public func parseJSON(_ json: JSON?, linksCallback: OnLinksCallback?) -> Error? {
        return nil
    }
}
