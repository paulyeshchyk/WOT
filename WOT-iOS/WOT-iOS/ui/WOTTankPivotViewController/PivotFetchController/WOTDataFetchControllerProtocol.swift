//
//  WOTDataFetchControllerProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTDataFetchControllerProtocol {
    func performFetch() throws
    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTPivotNodeProtocol]
    func setListener(_ listener: WOTDataFetchControllerListenerProtocol?)
}

@objc
protocol WOTDataFetchControllerListenerProtocol {
    func fetchPerformed(by: WOTDataFetchControllerProtocol)
    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error)
}
