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
    public func parseData(_ data: Data?, error: Error?, jsonLinksCallback: WOTJSONLinksCallback?) -> Error? {
        return nil
    }
    
    @objc
    public func parseJSON(_ json: JSON?, error: Error?, jsonLinksCallback: WOTJSONLinksCallback?) -> Error? {
        return nil
    }
    
    
}
