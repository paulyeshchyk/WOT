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
        case default_profile
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        let tankID = jSON[#keyPath(Vehicles.tank_id)]
        self.name = jSON[#keyPath(Vehicles.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(Vehicles.tier)]  as? Int ?? 0)
        self.tag = jSON[#keyPath(Vehicles.tag)] as? String
        self.tank_id = NSDecimalNumber(value: tankID as? Int ?? 0)
        self.nation = jSON[#keyPath(Vehicles.nation)] as? String
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Vehicles.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Vehicles.price_gold)]  as? Int ?? 0)
        self.is_premium = NSDecimalNumber(value: jSON[#keyPath(Vehicles.is_premium)]  as? Int ?? 0)
        self.is_gift = NSDecimalNumber(value: jSON[#keyPath(Vehicles.is_gift)]  as? Int ?? 0)
        self.short_name = jSON[#keyPath(Vehicles.short_name)] as? String
        self.type = jSON[#keyPath(Vehicles.type)] as? String

        subordinator?.willRequestLinks()

        #warning("do not parse on application startup")
        let vehicleProfileCase = PKCase()
        vehicleProfileCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))

        Vehicleprofile.profile(fromJSON: jSON[#keyPath(Vehicles.default_profile)], pkCase: vehicleProfileCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
            self.default_profile = newObject as? Vehicleprofile
        }

        /*
         if let set = self.modules_tree {
             self.removeFromModules_tree(set)
         }

         let modulesTreeCase = PKCase()
         modulesTreeCase[.primary] = pkCase[.primary]?
             .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
             .foreignKey(byInsertingComponent: #keyPath(ModulesTree.defaultProfile))
         ModulesTree.modulesTree(fromJSON: jSON[#keyPath(Vehicles.modules_tree)], pkCase: modulesTreeCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
             guard let module_tree = newObject as? ModulesTree else { return }
             self.addToModules_tree(module_tree)
         }
         */
    }
}

extension Vehicles: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(Vehicles.tag)

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

    public static func foreingKey(for ident: AnyObject?, foreignPaths: [String]) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }

        var fullPaths = foreignPaths
        fullPaths.append(self.pkey)
        let foreignPath = fullPaths.joined(separator: ".")

        return WOTPrimaryKey(name: foreignPath, value: ident as AnyObject, predicateFormat: "%K == %@")
    }
}
