//
//  WOTSaveSessionResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTSaveSessionResponseAdapter: NSObject, WOTWebResponseAdapterProtocol {
    @objc
    public var appManager: WOTAppManagerProtocol?

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish) -> JSONCoordinatorProtocol {
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
