//
//  WOTTankTreeFetchController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

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

        self.append(listofNodes: temporaryList, into: root)
        return [root]
    }

    private func append(listofNodes: [Int: WOTNodeProtocol], into root: WOTNodeProtocol) {
        listofNodes.forEach { (_, value) in
            guard let modulesTree = (value as? WOTTreeModuleNodeProtocol)?.modulesTree else {
                return
            }
            guard let nestedModules = modulesTree.nestedModules() else {
                root.addChild(value)
                return
            }
            nestedModules.forEach({ (module) in
                guard let prevNode = listofNodes[module.moduleIdInt()] else {
                    root.addChild(value)
                    return
                }
                prevNode.addChild(value)
            })
        }
    }

    typealias NodeCreateClosure = (Int, ModulesTree) -> Void

    private func transform(modulesSet: Set<ModulesTree>, withId tankId: NSDecimalNumber, nodeCreation: NodeCreateClosure) {
        modulesSet.forEach { (submodule) in
            if let moduleId = submodule.module_id?.intValue {
                if submodule.isCompatible(forTankId: tankId) {
                    nodeCreation(moduleId, submodule)
                }
            }
            self.transform(module: submodule, withId: tankId, nodeCreation: nodeCreation)
        }
    }

    private func transform(module: ModulesTree, withId tankId: NSDecimalNumber, nodeCreation: NodeCreateClosure) {
        guard let submodules = module.nextModules else {
            return
        }
        submodules.forEach({ (a_submodule) in
            guard let submodule = a_submodule as? ModulesTree else {
                return
            }

            if let moduleId = submodule.module_id?.intValue, submodule.isCompatible(forTankId: tankId) {
                nodeCreation(moduleId, submodule)
            }

            self.transform(module: submodule, withId: tankId, nodeCreation: nodeCreation)
        })
    }
}

extension ModulesTree: WOTTreeModulesTreeProtocol {
    public func moduleLocalImageURL() -> URL? {
        return nil
    }

    public func moduleName() -> String {
        return self.name
    }

    public func moduleValue(forKey: String) -> Any? {
        return nil
    }

    public func moduleIdInt() -> Int {
        return self.module_id.intValue
    }

    func isCompatible(forTankId: NSDecimalNumber) -> Bool {
        let result = self.nextTanks.filter({ (next) -> Bool in
            return (next as? Tanks)?.tank_id.intValue == forTankId.intValue
        })
        return (result.count != 0)
    }

    public func nestedModules() -> [WOTTreeModulesTreeProtocol]? {
        var result = [WOTTreeModulesTreeProtocol]()

        guard let modules = self.prevModules else {
            return result
        }
        result.append(modules)
        return result
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
