//
//  WOTTreeModuleNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTTreeModuleNode: WOTNode, WOTTreeModuleNodeProtocol {

    private(set)var modulesTree: ModulesTree
    var imageURL: URL? {
        guard let result = self.modulesTree.localImageURL() else {
            return nil
        }
        return result
    }

    @objc
    required init(moduleTree module: ModulesTree) {
        modulesTree = module
        super.init(name: module.name)
    }

    @objc
    public required init(name nameValue: String) {
        fatalError("init(name:) has not been implemented")
    }

    override func value(key: AnyHashable) -> Any? {
        guard let keyAsString = key as? String else {
            return nil
        }
        return modulesTree.value(forKey: keyAsString)
    }
}
