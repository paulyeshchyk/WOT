//
//  WOTTankTreeFetchController.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import WOTApi
import WOTPivot

@objc
class WOTTankTreeFetchController: WOTDataFetchController {
    override func fetchedNodes(byPredicates: [NSPredicate], nodeCreator: WOTNodeCreatorProtocol?, filteredCompletion: FilteredObjectCompletion) {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        var result = [WOTNodeProtocol]()

        let filtered = self.fetchedObjects()?.filter { predicate.evaluate(with: $0) }

        filtered?.forEach { fetchedObject in
            let transformed = self.transform(tank: fetchedObject, nodeCreator: nodeCreator)
            result.append(contentsOf: transformed)
        }
        filteredCompletion(predicate, result)
    }

    private func tankId(_ tank: AnyObject) -> NSNumber? {
        guard let tanks = tank as? Vehicles else {
            return nil
        }
        return tanks.tank_id
    }

    private func vehicleModules(_ vehicle: AnyObject) -> Set<ModulesTree>? {
        guard let vehicles = vehicle as? Vehicles else {
            return nil
        }
        return vehicles.modules_tree as? Set<ModulesTree>
    }

    private func transform(tank: AnyObject, nodeCreator: WOTNodeCreatorProtocol?) -> [WOTNodeProtocol] {
        guard let tankId = self.tankId(tank) else {
            return []
        }

        guard let root = nodeCreator?.createNode(fetchedObject: tank, byPredicate: nil) else {
            return []
        }

        guard let modules = self.vehicleModules(tank) else {
            return [root]
        }

        var temporaryList = [Int: WOTNodeProtocol]()
        let nodeCreation: NodeCreateClosure = { (id: Int, module: ModulesTree) in
            if let node = nodeCreator?.createNode(fetchedObject: module, byPredicate: nil) {
                temporaryList[id] = node
            } else {
                print("not created")
            }
        }

        self.transform(modulesSet: modules, withId: tankId, nodeCreation: nodeCreation)

        self.append(listofNodes: temporaryList, into: root)
        return [root]
    }

    private func append(listofNodes: [Int: WOTNodeProtocol], into root: WOTNodeProtocol) {
        listofNodes.forEach { ident, value in

            let parents = findTheParent(childId: ident, listOfNodes: listofNodes)
            if  parents.count > 0 {
                parents.forEach({$0.addChild(value)})
            } else {
                root.addChild(value)
            }
        }
    }

    private func findTheParent(childId: Int, listOfNodes: [Int: WOTNodeProtocol]) -> [WOTNodeProtocol] {
        var foundParents: [WOTNodeProtocol] = []

        listOfNodes.forEach { (element) in
            if let next_nodesId = (element.value as? WOTTreeModuleNodeProtocol)?.modulesTree.next_nodesId() {
                if next_nodesId.contains(childId) {
                    foundParents.append(element.value)
                }
            }
        }

        return foundParents
    }

    typealias NodeCreateClosure = (Int, ModulesTree) -> Void

    private func transform(modulesSet: Set<ModulesTree>, withId tankId: NSNumber, nodeCreation: NodeCreateClosure) {
        modulesSet.forEach { submodule in
            if let moduleId = submodule.module_id?.intValue {
                if submodule.isCompatible(forTankId: tankId) {
                    nodeCreation(moduleId, submodule)
                } else {
                    print("not compatible")
                }
            }
            self.transform(modulesTree: submodule, withId: tankId, nodeCreation: nodeCreation)
        }
    }

    private func transform(modulesTree: ModulesTree, withId tankId: NSNumber, nodeCreation: NodeCreateClosure) {
        guard let submodules = modulesTree.next_modules as? Set<ModulesTree>, submodules.count > 0 else {
            return
        }
        submodules.forEach { submodule in
            if let moduleId = submodule.module_id?.intValue, submodule.isCompatible(forTankId: tankId) {
                nodeCreation(moduleId, submodule)
            }

            self.transform(modulesTree: submodule, withId: tankId, nodeCreation: nodeCreation)
        }
    }
}

extension ModulesTree: WOTTreeModulesTreeProtocol {
    public func moduleType() -> String? {
        return self.type
    }

    public func moduleLocalImageURL() -> URL? {
        guard let imageName = self.type else {
            return nil
        }
        guard let path = Bundle.main.url(forResource: imageName, withExtension: "png") else {
            return nil
        }
        return path
    }

    public func moduleName() -> String {
        return self.name ?? ""
    }

    public func moduleValue(forKey: String) -> Any? {
        return nil
    }

    public func moduleIdInt() -> Int {
        return self.module_id!.intValue
    }

    func isCompatible(forTankId: NSNumber) -> Bool {
        guard let tanksSet = self.next_tanks as? Set<Vehicles> else { return false }
        let filtered = tanksSet.filter { $0.tank_id?.intValue == forTankId.intValue }
        return filtered.count > 0
    }

    public func next_nodesId() -> [Int]? {
        return self.next_modules?.compactMap {
            ($0 as? Module)?.module_id?.intValue
        }
    }
}
