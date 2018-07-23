//
//  WOTTreeModuleNodeProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTTreeModuleNodeProtocol: WOTNodeProtocol {

    var modulesTree: ModulesTree { get }
    var imageURL: NSURL? { get }
}
