//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
public protocol WOTJSONResponseAdapterProtocol: NSObjectProtocol {
    init(appManager: WOTAppManagerProtocol?)
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish ) -> JSONAdapterProtocol
}

@objc
open class WOTJSONResponseAdapter: NSObject, WOTJSONResponseAdapterProtocol {
    //
    public var appManager: WOTAppManagerProtocol?

    open var Clazz: PrimaryKeypathProtocol.Type { fatalError("should be overriden")}

    required public init(appManager app: WOTAppManagerProtocol?) {
        appManager = app
    }

    open func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        fatalError("should be overriden")
    }

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish) -> JSONAdapterProtocol {
        let store = JSONAdapter(Clazz: Clazz, request: request, appManager: appManager)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onFinishJSONParse = onFinish
        store.onCreateNSManagedObject = onCreateNSManagedObject
        return store
    }
}
