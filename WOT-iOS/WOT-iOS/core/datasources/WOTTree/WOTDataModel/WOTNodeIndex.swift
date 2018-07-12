//
//  WOTNodeIndex.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/12/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTNodeIndexProtocol: NSObjectProtocol {

    func makeIndex()

}

@objc
class WOTNodeIndex: NSObject, WOTNodeIndexProtocol {
    private var largeIndex = Dictionary<AnyHashable, Any> ()

    func makeIndex() {

        largeIndex.removeAll()
    }
}
