//
//  Vehicles_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Vehicles: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Vehicles.name),
                #keyPath(Vehicles.short_name),
                #keyPath(Vehicles.is_premium),
                #keyPath(Vehicles.is_gift),
                #keyPath(Vehicles.type),
                #keyPath(Vehicles.nation),
                #keyPath(Vehicles.tag),
                #keyPath(Vehicles.tier),
                #keyPath(Vehicles.tank_id),
                #keyPath(Vehicles.default_profile),
                #keyPath(Vehicles.modules_tree),
                #keyPath(Vehicles.engines),
                #keyPath(Vehicles.suspensions),
                #keyPath(Vehicles.radios),
                #keyPath(Vehicles.guns),
                #keyPath(Vehicles.turrets)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Vehicles.keypaths()
    }
}

extension Vehicles {
    public enum FieldKeys: String, CodingKey {
        case is_premium_igr
        case is_wheeled
        case name
        case nation
        case price_credit
        case price_gold
        case is_premium
        case is_gift
        case short_name
        case tag
        case tier
        case type
        case tank_id
        case modules_tree
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(Vehicles.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(Vehicles.tier)]  as? Int ?? 0)
        self.tag = jSON[#keyPath(Vehicles.tag)] as? String
        self.tank_id = NSDecimalNumber(value: jSON[#keyPath(Vehicles.tank_id)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Vehicles.nation)] as? String
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Vehicles.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Vehicles.price_gold)]  as? Int ?? 0)
        self.is_premium = NSDecimalNumber(value: jSON[#keyPath(Vehicles.is_premium)]  as? Int ?? 0)
        self.is_gift = NSDecimalNumber(value: jSON[#keyPath(Vehicles.is_gift)]  as? Int ?? 0)
        self.short_name = jSON[#keyPath(Vehicles.short_name)] as? String
        self.type = jSON[#keyPath(Vehicles.type)] as? String

        guard let intID = jSON[#keyPath(Vehicles.tank_id)] as? Int else { return }
        if let pkProfile = Vehicleprofile.primaryKey(for: String(intID) as AnyObject) {
            self.default_profile = Vehicleprofile.profile(from: jSON[#keyPath(Vehicles.default_profile)], primaryKey: pkProfile, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        }

        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        if let pkModulesTree = ModulesTree.primaryKey(for: String(intID) as AnyObject) {
            if let modulesTreeJSON = jSON[#keyPath(Vehicles.modules_tree)] {
                let module_tree = mapping(modulestreeJson: modulesTreeJSON, parentPrimaryKey: pkModulesTree, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
                module_tree?.forEach {
                    self.addToModules_tree($0)
                }
            }
        }
    }

    func mapping(modulestreeJson json: Any?, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> [ModulesTree]? {
        guard let json = json as? JSON else { return nil }

        var result = [ModulesTree]()
        json.keys.forEach { (key) in
            guard let moduleTreeJSON = json[key] as? JSON,
                let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else {
                return
            }

            guard let moduleTree = mapping(moduletreeJson: moduleTreeJSON, module_id: module_id, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback) else { return }
            result.append(moduleTree)
        }
        return result
    }

    func mapping(moduletreeJson json: Any?, module_id: NSNumber, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> ModulesTree? {
        guard let json = json as? JSON else { return nil }
        guard
            let pk = ModulesTree.primaryKey(for: module_id),
            let result = onSubordinateCreate?(ModulesTree.self, pk) as? ModulesTree
        else {
            return nil
        }
        result.mapping(fromJSON: json, parentPrimaryKey: pk, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

extension Vehicles: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(Vehicles.tank_id)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, predicateFormat: "%K == %@")
    }
}
