//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
public protocol WOTDataResponseAdapterProtocol: NSObjectProtocol {
    init(appManager: WOTAppManagerProtocol?)
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, onCreateNSManagedObject: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete ) -> JSONAdapterProtocol
}

@objc
open class WOTJSONResponseAdapter: NSObject, WOTDataResponseAdapterProtocol {
    //
    public var appManager: WOTAppManagerProtocol?

    open var Clazz: PrimaryKeypathProtocol.Type { fatalError("should be overriden")}

    required public init(appManager app: WOTAppManagerProtocol?) {
        appManager = app
    }

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, onCreateNSManagedObject: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete) -> JSONAdapterProtocol {
        let store = JSONAdapter(Clazz: Clazz, request: request, appManager: appManager)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onRequestComplete = onRequestComplete
        store.onCreateNSManagedObject = onCreateNSManagedObject
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
