//
//  ModulesTree+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ModulesTree)
public class ModulesTree: NSManagedObject {}

// MARK: - Coding Keys
extension ModulesTree {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case next_modules
        case next_tanks
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        return #keyPath(ModulesTree.module_id)
    }
}

// MARK: - Mapping
extension ModulesTree {
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)

        var parents = pkCase.plainParents
        parents.append(self)

        let nextModules = jSON[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let modulePK = PKCase(parentObjects: parents)
            modulePK[.primary] = pkCase[.primary]
            modulePK[.secondary] = Module.primaryIdKey(for: $0)
            persistentStore?.fetchRemote(byModelClass: Module.self, pkCase: modulePK, keypathPrefix: nil, onObjectDidFetch: { (managedObject, _) in
                if let module = managedObject as? Module {
                    self.addToNext_modules(module)
                    persistentStore?.stash(hint: modulePK)
                }
            })
        }

        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            //parents was not used for next portion of tanks
            let nextTanksPK = PKCase(parentObjects: nil)
            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0)
            persistentStore?.fetchRemote(byModelClass: Vehicles.self, pkCase: nextTanksPK, keypathPrefix: nil, onObjectDidFetch: { (managedObject, _) in
                if let tank = managedObject as? Vehicles {
                    self.addToNext_tanks(tank)
                    persistentStore?.stash(hint: nextTanksPK)
                }
            })
        }
    }
}

// MARK: - JSONDecoding
extension ModulesTree: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let fieldsContainer = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try fieldsContainer.decodeIfPresent(String.self, forKey: .name)
        self.type = try fieldsContainer.decodeIfPresent(String.self, forKey: .type)
        self.module_id = try fieldsContainer.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        self.price_credit = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        self.price_xp = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_xp)?.asDecimal
        self.is_default = try fieldsContainer.decodeIfPresent(Bool.self, forKey: .is_default)?.asDecimal
    }
}

// MARK: - Customization
extension ModulesTree {
    @objc
    public func localImageURL() -> URL? {
        let type = self.moduleType()
        let name = type.stringValue
        return Bundle.main.url(forResource: name, withExtension: "png")
    }

    @objc
    public func moduleType() -> ObjCVehicleModuleType {
        return .unknown
    }
}
