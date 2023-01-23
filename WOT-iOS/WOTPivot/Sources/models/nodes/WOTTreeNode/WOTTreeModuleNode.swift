//
//  WOTTreeModuleNode.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

@objc
public class WOTTreeModuleNode: WOTNode, WOTTreeModuleNodeProtocol {
    public private(set) var modulesTree: WOTTreeModulesTreeProtocol
    public var imageURL: URL? {
        return modulesTree.moduleLocalImageURL()
    }

    @objc
    public required init(moduleTree module: WOTTreeModulesTreeProtocol) {
        modulesTree = module
        super.init(name: module.moduleName())
    }

    @objc
    public required init(name _: String) {
        fatalError("init(name:) has not been implemented")
    }

    override public func value(key: AnyHashable) -> Any? {
        guard let keyAsString = key as? String else {
            return nil
        }
        return modulesTree.moduleValue(forKey: keyAsString)
    }
}
