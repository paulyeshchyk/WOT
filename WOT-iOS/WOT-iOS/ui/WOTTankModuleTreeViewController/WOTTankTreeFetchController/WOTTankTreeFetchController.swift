//
//  WOTTankTreeFetchController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTTankTreeFetchController: WOTDataTanksFetchController {

    override func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol] {

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        var result = [WOTNodeProtocol]()

        let filtered = self.fetchedObjects()?.filter { predicate.evaluate(with: $0) }

        filtered?.forEach { (fetchedObject) in
            let transformed = self.transform(tank: fetchedObject)
            result.append(contentsOf: transformed)
        }
        return result
    }

    private func transform(tank: AnyObject) -> [WOTNodeProtocol] {
        guard let tanks = tank as? Tanks else {
            return []
        }
        guard let tankId = tanks.tank_id else {
            return []
        }
        let root = self.nodeCreator.createNode(fetchedObject: tanks, byPredicate: nil)

        guard let modules = tanks.modulesTree as? Set<ModulesTree> else {
            return [root]
        }

        guard var plainList = self.transform(modulesSet: modules, withId: tankId) as? [Int: WOTTreeModuleNodeProtocol] else {
            return [root]
        }

        plainList.forEach { (_, value) in
            guard let prevModule = value.modulesTree.prevModules else {
                root.addChild(value)
                return
            }
            if let prevNode = plainList[prevModule.module_id.intValue] {
                prevNode.addChild(value)
            } else {
                root.addChild(value)
            }
        }
        return [root]
    }

    private func transform(modulesSet: Set<ModulesTree>, withId tankId: NSDecimalNumber) -> [Int: WOTNodeProtocol] {
        var plainList = [Int: WOTNodeProtocol]()
        modulesSet.forEach { (submodule) in
            let childNode = self.nodeCreator.createNode(fetchedObject: submodule, byPredicate: nil)
            plainList[submodule.module_id.intValue] = childNode

            let sub = self.transform(module: submodule, withId: tankId)
            plainList = plainList.merge(with: sub)
        }
        return plainList
    }

    private func transform(module: ModulesTree, withId tankId: NSDecimalNumber) -> [Int: WOTNodeProtocol] {
        var plainList = [Int: WOTNodeProtocol]()

        let plainchildNode = self.nodeCreator.createNode(fetchedObject: module, byPredicate: nil)
        plainList[module.module_id.intValue] = plainchildNode

        guard let setOfSubmodules = module.plainList(forVehicleId: tankId) else {
            return plainList
        }
        setOfSubmodules.forEach({ (subsub) in
            guard let subsubmodule = subsub as? ModulesTree else {
                return
            }

            let submoduleNodes = self.transform(module: subsubmodule, withId: tankId)
            plainList = plainList.merge(with: submoduleNodes)
        })
        return plainList
    }
}

/*
 https://medium.com/ios-swift-development-notes/swiftbites-8-merging-dictionaries-in-swift-894c3e235fec
 */
extension Dictionary {
    /// Merge and return a new dictionary
    func merge(with: [Key: Value]) -> [Key: Value] {
        var copy = self
        for (k, v) in with {
            // If a key is already present it will be overritten
            copy[k] = v
        }
        return copy
    }

    /// Merge in-place
    mutating func append(with: [Key: Value]) {
        for (k, v) in with {
            // If a key is already present it will be overritten
            self[k] = v
        }
    }
}
