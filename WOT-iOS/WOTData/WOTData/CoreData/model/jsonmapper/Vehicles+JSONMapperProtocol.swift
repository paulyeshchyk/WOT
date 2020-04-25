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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let vehicleProfileCase = PKCase()
        vehicleProfileCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))

        Vehicleprofile.profile(fromJSON: jSON[#keyPath(Vehicles.default_profile)], pkCase: vehicleProfileCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            guard let defaultProfile = newObject as? Vehicleprofile else {
                return
            }
            self.default_profile = defaultProfile
            self.modules_tree?.forEach({ (element) in
                if let modules_tree = element as? ModulesTree {
                    modules_tree.default_profile = defaultProfile
                }
            })
            coreDataMapping?.stash(hint: vehicleProfileCase)
        }

        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        let modulesTreeCase = PKCase()
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        ModulesTree.modulesTree(fromJSON: jSON[#keyPath(Vehicles.modules_tree)], pkCase: modulesTreeCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            guard let module_tree = newObject as? ModulesTree else {
                return
            }
            module_tree.default_profile = self.default_profile
            self.addToModules_tree(module_tree)
            coreDataMapping?.stash(hint: modulesTreeCase)
        }
    }
}
