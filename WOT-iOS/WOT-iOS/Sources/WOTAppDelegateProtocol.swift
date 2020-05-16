//
//  WOTAppDelegateProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTAppDelegateProtocol {
    var appManager: WOTAppManagerProtocol { get }
}
