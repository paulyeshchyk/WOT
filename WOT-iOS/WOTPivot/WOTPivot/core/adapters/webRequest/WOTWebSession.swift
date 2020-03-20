//
//  WOTWebSession.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTWebSessionManagerProtocol {

    @objc
    func login()
    
    @objc
    func logout()
}
