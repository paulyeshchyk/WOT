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
    init(fetchController: NodeFetchControllerProtocol, modelListener: NodeDataModelListener, nodeCreator: NodeCreatorProtocol, nodeIndexType: NodeIndexProtocol.Type)
}
