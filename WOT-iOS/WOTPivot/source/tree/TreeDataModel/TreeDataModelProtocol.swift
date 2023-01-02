//
//  TreeDataModelProtocol.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK

@objc
public protocol TreeDataModelProtocol: NodeDataModelProtocol {
    var levels: Int { get }
    var width: Int { get }
    init(fetchController: NodeFetchControllerProtocol, listener: NodeDataModelListener, enumerator: NodeEnumeratorProtocol, nodeCreator: NodeCreatorProtocol, nodeIndex: NodeIndexProtocol, appContext: NodeFetchControllerProtocol.Context)
}
