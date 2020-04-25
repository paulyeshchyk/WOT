//
//  WOTTreeDataModelProtocol.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol WOTTreeProtocol: NSObjectProtocol {
    func findOrCreateRootNode(forPredicate: NSPredicate) -> WOTNodeProtocol
}

@objc
public protocol WOTTreeDataModelProtocol: WOTDataModelProtocol {
    var levels: Int { get }
    var width: Int { get }
    init(fetchController: WOTDataFetchControllerProtocol, listener: WOTDataModelListener, enumerator: WOTNodeEnumeratorProtocol, nodeCreator: WOTNodeCreatorProtocol)
}
