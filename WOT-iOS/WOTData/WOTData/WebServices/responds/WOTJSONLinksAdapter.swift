//
//  WOTJSONLinksAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONLinksAdapter: NSObject, JSONLinksAdapterProtocol {
    public var appManager: WOTAppManagerProtocol?

    @objc
    public func request(_ parentRequest: WOTRequestProtocol, adaptExternalLinks jsonLinks: ([WOTJSONLink])?, externalCallback: NSManagedObjectCallback?, adaptCallback: @escaping (WOTRequestManagerCompletionResultType) -> Void) {
        guard let jsonLinks = jsonLinks, jsonLinks.count != 0 else {
            adaptCallback(.noData)
            return
        }

        jsonLinks.compactMap { $0 }.forEach { jsonLink in
            if let requestIDs = appManager?.requestManager?.coordinator.requestIds(forClass: jsonLink.clazz) {
                requestIDs.forEach {
                    appManager?.requestManager?.queue(parentRequest: parentRequest, requestId: $0, jsonLink: jsonLink, externalCallback: externalCallback, listener: nil)
                }
            } else {
                print("requests not parsed")
            }
        }
    }
}