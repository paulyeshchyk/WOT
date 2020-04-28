//
//  Vehicles+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vehicles)
public class Vehicles: NSManagedObject {}

// MARK: - Coding Keys
extension Vehicles {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case is_gift
        case is_premium
        case is_premium_igr
        case is_wheeled
        case name
        case nation
        case price_credit
        case price_gold
        case short_name
        case tag
        case tank_id
        case tier
        case type
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case default_profile
        case engines
        case guns
        case radios
        case modules_tree
        case suspensions
        case turrets
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public static func primaryKeyPath() -> String {
        return #keyPath(Vehicles.tank_id)
    }
}

// MARK: - Mapping
extension Vehicles {
    private func defaultProfileMapping(jSON: JSON?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        guard let itemJSON = jSON else { return }

        let vehicleProfileCase = PKCase()
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

    private func modulesTreeMapping(jSON: JSON?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            return
        }

        var parents = pkCase.plainParents
        parents.append(self)
        let modulesTreeCase = PKCase(parentObjects: parents)
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        moduleTreeJSON.keys.forEach { (key) in
            guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber  else { return }

            let modulePK = ModulesTree.primaryKey(for: module_id)
            let submodulesCase = PKCase(parentObjects: modulesTreeCase.plainParents)
            submodulesCase[.primary] = modulePK
            submodulesCase[.secondary] = modulesTreeCase[.primary]

            try? persistentStore?.fetchLocal(byModelClass: ModulesTree.self, pkCase: submodulesCase) { newObject in
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

    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        defaultProfileMapping(jSON: jSON[#keyPath(Vehicles.default_profile)] as? JSON, pkCase: pkCase, persistentStore: persistentStore)

        modulesTreeMapping(jSON: jSON[#keyPath(Vehicles.modules_tree)] as? JSON, pkCase: pkCase, persistentStore: persistentStore)
    }
}

// MARK: - JSONDecoding
extension Vehicles: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.short_name = try container.decodeIfPresent(String.self, forKey: .short_name)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.tag = try container.decodeIfPresent(String.self, forKey: .tag)
        self.tank_id = try container.decodeIfPresent(Int.self, forKey: .tank_id)?.asDecimal
        self.nation = try container.decodeIfPresent(String.self, forKey: .nation)
        self.price_credit = try container.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        self.price_gold = try container.decodeIfPresent(Int.self, forKey: .price_gold)?.asDecimal
        self.is_premium = try container.decodeIfPresent(Bool.self, forKey: .is_premium)?.asDecimal
        self.is_premium_igr = try container.decodeIfPresent(Bool.self, forKey: .is_premium_igr)?.asDecimal
        self.is_gift = try container.decodeIfPresent(Bool.self, forKey: .is_gift)?.asDecimal
    }
}
