//
//  WOTWebResponseAdapterRadios.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONResponseAdapterRadios: WOTJSONResponseAdapter {
//
    override public var Clazz: PrimaryKeypathProtocol.Type { return VehicleprofileRadio.self }
}
