//
//  WOTPivotAppManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTPivotAppManagerProtocol {

    @objc
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }
    
    @objc
    var requestManager: WOTRequestManagerProtocol? { get set }
    
    @objc
    var requestListener: WOTRequestListenerProtocol? { get set }
}


@objc
public class WOTPivotAppManager: NSObject, WOTPivotAppManagerProtocol {
 
    @objc
    public var hostConfiguration: WOTHostConfigurationProtocol?

    @objc
    public var requestManager: WOTRequestManagerProtocol?
    
    @objc
    public var requestListener: WOTRequestListenerProtocol?
}
