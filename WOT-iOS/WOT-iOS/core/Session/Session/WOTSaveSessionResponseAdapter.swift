//
//  WOTSaveSessionResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTSaveSessionResponseAdapter: NSObject, WOTWebResponseAdapter {
    public func parseData(_ data: Data?, error: Error?, jsonLinksCallback: WOTJSONLinksCallback?) -> Error? {
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
        return nil
    }
}
