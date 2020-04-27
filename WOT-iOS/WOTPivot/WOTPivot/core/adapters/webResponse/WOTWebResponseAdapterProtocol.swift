//
//  WOTWebResponseAdapter.swift
//  WOTPivot
//
//  Created on 2/19/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
public protocol WOTWebResponseAdapterProtocol: NSObjectProtocol {
    @objc
    var appManager: WOTAppManagerProtocol? { get set }

    func request(_ request: WOTRequestProtocol, parseData binary: Data?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish ) -> JSONCoordinatorProtocol
}

@objc
open class WOTWebResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    //
    public var appManager: WOTAppManagerProtocol?

    open var Clazz: PrimaryKeypathProtocol.Type { fatalError("should be overriden")}

    open func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        fatalError("should be overriden")
    }

    open func request(_ request: WOTRequestProtocol, parseData data: Data?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish) -> JSONCoordinatorProtocol {
        let store = JSONCoordinator(Clazz: Clazz, request: request, appManager: appManager)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onFinishJSONParse = onFinish
        store.onCreateNSManagedObject = onCreateNSManagedObject
        return store
    }
}
