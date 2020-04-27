//
//  WOTWebResponseAdapterProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterProfile: WOTWebResponseAdapter {
    override public var Clazz: PrimaryKeypathProtocol.Type { return Vehicleprofile.self }

    override public func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        let primaryKeyPath = Clazz.primaryKeyPath()
        #warning("check the case")
        if  primaryKeyPath.count > 0 {
            ident = (json[primaryKeyPath] as? JSON)?.asURLQueryString().hashValue ?? key
        } else {
            ident = key
        }
        return ident
    }
}
