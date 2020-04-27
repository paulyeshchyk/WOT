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
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        if let itemJSON = jSON[#keyPath(Vehicles.default_profile)] as? JSON {
            let vehicleProfileCase = RemotePKCase()
            vehicleProfileCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))
            persistentStore?.itemMapping(forClass: Vehicleprofile.self, itemJSON: itemJSON, pkCase: vehicleProfileCase, callback: { (managedObject) in
                guard let defaultProfile = managedObject as? Vehicleprofile else {
                    return
                }
                self.default_profile = defaultProfile
                self.modules_tree?.forEach({ (element) in
                    (element as? ModulesTree)?.default_profile = defaultProfile
                })
            })
        }

        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        var parents = pkCase.plainParents
        parents.append(self)
        let modulesTreeCase = RemotePKCase(parentObjects: parents)
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        if let moduleTreeJSON = jSON[#keyPath(Vehicles.modules_tree)] as? JSON {
            moduleTreeJSON.keys.forEach { (key) in
                guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
                guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber  else { return }

                let modulePK = ModulesTree.primaryKey(for: module_id)
                let submodulesCase = RemotePKCase(parentObjects: modulesTreeCase.plainParents)
                submodulesCase[.primary] = modulePK
                submodulesCase[.secondary] = modulesTreeCase[.primary]

                persistentStore?.localSubordinate(for: ModulesTree.self, pkCase: submodulesCase) { newObject in
                    guard let module_tree = newObject as? ModulesTree else {
                        return
                    }
                    persistentStore?.mapping(object: newObject, fromJSON: moduleTreeJSON, pkCase: modulesTreeCase)

                    module_tree.default_profile = self.default_profile
                    self.addToModules_tree(module_tree)
                    persistentStore?.stash(hint: modulesTreeCase)
                }
            }
        }
    }
}
