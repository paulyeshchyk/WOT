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
    @objc
    public var appManager: WOTAppManagerProtocol?

    required public init(appManager app: WOTAppManagerProtocol?, clazz: PrimaryKeypathProtocol.Type) {
        appManager = app
    }

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, instanceHelper: JSONAdapterInstanceHelper?, onRequestComplete: @escaping OnRequestComplete) -> JSONAdapterProtocol {
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
