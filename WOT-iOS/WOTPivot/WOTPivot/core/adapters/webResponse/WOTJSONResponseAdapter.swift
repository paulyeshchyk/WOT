//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
open class WOTJSONResponseAdapter: NSObject, WOTDataResponseAdapterProtocol {
    //
    public var appManager: WOTAppManagerProtocol?

    open var modelClass: PrimaryKeypathProtocol.Type

    required public init(appManager app: WOTAppManagerProtocol?, clazz: PrimaryKeypathProtocol.Type) {
        appManager = app
        modelClass = clazz
    }

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, instanceHelper: JSONAdapterInstanceHelper?, onRequestComplete: @escaping OnRequestComplete) -> JSONAdapterProtocol {
        let jsonAdapter: JSONAdapterProtocol = JSONAdapter(Clazz: modelClass, request: request, appManager: appManager)
        jsonAdapter.onJSONDidParse = onRequestComplete
        jsonAdapter.instanceHelper = instanceHelper
        return jsonAdapter
    }
}
