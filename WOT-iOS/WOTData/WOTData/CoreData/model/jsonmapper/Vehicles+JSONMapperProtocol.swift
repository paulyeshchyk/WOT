//
//  Vehicles_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension Vehicles {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let vehicleProfileCase = PKCase()
        vehicleProfileCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))

        Vehicleprofile.profile(fromJSON: jSON[#keyPath(Vehicles.default_profile)], pkCase: vehicleProfileCase, persistentStore: persistentStore) { newObject in
            guard let defaultProfile = newObject as? Vehicleprofile else {
                return
            }
            self.default_profile = defaultProfile
            self.modules_tree?.forEach({ (element) in
                if let modules_tree = element as? ModulesTree {
                    modules_tree.default_profile = defaultProfile
                }
            })
            persistentStore?.stash(hint: vehicleProfileCase)
        }

        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        var parents = pkCase.plainParents
        parents.append(self)
        let modulesTreeCase = PKCase(parentObjects: parents)
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        ModulesTree.modulesTree(fromJSON: jSON[#keyPath(Vehicles.modules_tree)], pkCase: modulesTreeCase, persistentStore: persistentStore) { newObject in
            guard let module_tree = newObject as? ModulesTree else {
                return
            }
            module_tree.default_profile = self.default_profile
            self.addToModules_tree(module_tree)
            persistentStore?.stash(hint: modulesTreeCase)
        }
    }
}
