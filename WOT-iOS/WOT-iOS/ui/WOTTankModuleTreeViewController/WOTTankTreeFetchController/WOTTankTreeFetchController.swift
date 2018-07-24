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

    private func tankId(_ tank: AnyObject) -> NSDecimalNumber? {
        guard let tanks = tank as? Tanks else {
            return nil
        }
        return tanks.tank_id
    }

    private func tankModules(_ tank: AnyObject) -> Set<ModulesTree>? {
        guard let tanks = tank as? Tanks else {
            return nil
        }
        guard let modules = tanks.modulesTree as? Set<ModulesTree> else {
            return nil
        }
        return modules
    }

    private func transform(tank: AnyObject) -> [WOTNodeProtocol] {
        guard let tankId = self.tankId(tank) else {
            return []
        }

        let root = self.nodeCreator.createNode(fetchedObject: tank, byPredicate: nil)

        guard let modules = self.tankModules(tank) else {
            return [root]
        }

        var temporaryList = [Int: WOTNodeProtocol]()
        let nodeCreation: NodeCreateClosure = { (id: Int, module: ModulesTree) in
            let node = self.nodeCreator.createNode(fetchedObject: module, byPredicate: nil)
            temporaryList[id] = node
        }

        self.transform(modulesSet: modules, withId: tankId, nodeCreation: nodeCreation)

        temporaryList.forEach { (_, value) in
            guard let modulesTree = (value as? WOTTreeModuleNodeProtocol)?.modulesTree else {
                return
            }
            guard let prevModule = modulesTree.prevModules else {
                root.addChild(value)
                return
            }
            guard let prevNode = temporaryList[prevModule.module_id.intValue] else {
                root.addChild(value)
                return
            }
            prevNode.addChild(value)
        }
        return [root]
    }

    typealias NodeCreateClosure = (Int, ModulesTree) -> Void

    private func transform(modulesSet: Set<ModulesTree>, withId tankId: NSDecimalNumber, nodeCreation: NodeCreateClosure) {

        modulesSet.forEach { (submodule) in
            if let moduleId = submodule.module_id?.intValue {
                nodeCreation(moduleId, submodule)
            }
            self.transform(module: submodule, withId: tankId, nodeCreation: nodeCreation)
        }
    }

    private func transform(module: ModulesTree, withId tankId: NSDecimalNumber, nodeCreation: NodeCreateClosure) {
        guard let submodules = module.plainList(forVehicleId: tankId) else {
            return
        }
        submodules.forEach({ (a_submodule) in
            guard let submodule = a_submodule as? ModulesTree else {
                return
            }

            if let moduleId = submodule.module_id?.intValue {
                nodeCreation(moduleId, submodule)
            }

            self.transform(module: submodule, withId: tankId, nodeCreation: nodeCreation)
        })
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
