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
        self.name = jSON[#keyPath(Vehicles.name)] as? String
        self.tier = AnyConvertable(jSON[#keyPath(Vehicles.tier)]).asNSDecimal
        self.tag = AnyConvertable(jSON[#keyPath(Vehicles.tag)]).asString
        self.tank_id = AnyConvertable(jSON[#keyPath(Vehicles.tank_id)]).asNSDecimal
        self.nation = jSON[#keyPath(Vehicles.nation)] as? String
        self.price_credit = AnyConvertable(jSON[#keyPath(Vehicles.price_credit)]).asNSDecimal
        self.price_gold = AnyConvertable(jSON[#keyPath(Vehicles.price_gold)]).asNSDecimal
        self.is_premium = AnyConvertable(jSON[#keyPath(Vehicles.is_premium)]).asNSDecimal
        self.is_gift = AnyConvertable(jSON[#keyPath(Vehicles.is_gift)]).asNSDecimal
        self.short_name = jSON[#keyPath(Vehicles.short_name)] as? String
        self.type = jSON[#keyPath(Vehicles.type)] as? String

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
            coreDataMapping?.stash(vehicleProfileCase)
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
            coreDataMapping?.stash(modulesTreeCase)
        }
    }
}
