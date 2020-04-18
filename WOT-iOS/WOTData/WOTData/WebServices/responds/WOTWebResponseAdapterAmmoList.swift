//
//  WOTWebResponseAdapterAmmoList.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterAmmoList: NSObject, WOTWebResponseAdapter {
    @objc
    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapter) -> Error? {
        return nil
    }

    @objc
    public func parseJSON(_ json: JSON?, linksCallback: @escaping ([WOTJSONLink]?) -> Void) -> Error? {
        return nil
    }
}
