//
//  WOTDataResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
open class WOTJSONResponseAdapter: NSObject, WOTDataResponseAdapterProtocol {
    //
    public var logInspector: LogInspectorProtocol?
    public var coreDataStore: WOTCoredataStoreProtocol?

    open var modelClass: PrimaryKeypathProtocol.Type

    required public init(clazz: PrimaryKeypathProtocol.Type) {
        modelClass = clazz
    }

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, linker: JSONAdapterLinkerProtocol, decoderAndMapper: WOTDecodeAndMappingProtocol, onRequestComplete: @escaping OnRequestComplete) -> JSONAdapterProtocol {
        let jsonAdapter: JSONAdapterProtocol = JSONAdapter(Clazz: modelClass, request: request, logInspector: logInspector, coreDataStore: coreDataStore, linker: linker, decoderAndMapper: decoderAndMapper)
        jsonAdapter.onJSONDidParse = onRequestComplete
        return jsonAdapter
    }
}
