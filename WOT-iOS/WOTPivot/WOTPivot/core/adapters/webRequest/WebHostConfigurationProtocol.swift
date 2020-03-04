//
//  WebHostConfigurationProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WebHostConfigurationProtocol {

    @objc
    var applicationID: String { get }
    
    @objc
    var host: String { get }
    
    @objc
    var scheme: String { get }
}
