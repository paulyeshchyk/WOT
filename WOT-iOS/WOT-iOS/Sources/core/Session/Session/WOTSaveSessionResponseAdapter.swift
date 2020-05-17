//
//  WOTSaveSessionResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTSaveSessionResponseAdapter: NSObject, WOTDataResponseAdapterProtocol {

    public var logInspector: LogInspectorProtocol?
    public var coreDataStore: WOTCoredataStoreProtocol?

    required public init(clazz: PrimaryKeypathProtocol.Type) {
    }

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, linker: JSONAdapterLinkerProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol, onRequestComplete: @escaping OnRequestComplete) -> JSONAdapterProtocol {
        fatalError("not implemented")
//        WOTSessionManager.sharedInstance()?.invalidateTimer({ (interval) -> Timer? in
//            if #available(iOS 10.0, *) {
//                let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in
//                    WOTSessionManager.logout(withRequest: WOTRequestManager.sharedInstance)
//                })
//                return timer
//            } else {
//                return nil
//            }
//        })
//
//        onFinish(nil)
    }
}
