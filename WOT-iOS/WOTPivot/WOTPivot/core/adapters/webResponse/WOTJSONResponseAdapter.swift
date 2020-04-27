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

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, onCompleteObjectCreationL1: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete) -> JSONAdapterProtocol {
        let store: JSONAdapterProtocol = JSONAdapter(Clazz: modelClass, request: request, appManager: appManager)
        store.onComplete = onRequestComplete
        store.onCompleteObjectCreation = onCompleteObjectCreationL1
        return store
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        let primaryKeyPath = Clazz.primaryKeyPath()

        if  primaryKeyPath.count > 0 {
            ident = json[primaryKeyPath] ?? key
        } else {
            ident = key
        }
        return ident
    }
}
