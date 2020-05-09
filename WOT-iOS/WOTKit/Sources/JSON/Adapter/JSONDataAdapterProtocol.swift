//
//  JSONAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    var linker: JSONAdapterLinkerProtocol { get set }
    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?, linker: JSONAdapterLinkerProtocol)
}
