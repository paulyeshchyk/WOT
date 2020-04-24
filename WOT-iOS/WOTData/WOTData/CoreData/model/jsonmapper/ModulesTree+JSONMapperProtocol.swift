//
//  ModulesTree_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension ModulesTree: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(ModulesTree.name),
                //recursion                #keyPath(ModulesTree.next_modules),
                #keyPath(ModulesTree.next_tanks),
                #keyPath(ModulesTree.is_default),
                #keyPath(ModulesTree.price_xp),
                #keyPath(ModulesTree.price_credit),
                #keyPath(ModulesTree.module_id),
                #keyPath(ModulesTree.type)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return ModulesTree.keypaths()
    }
}

extension ModulesTree {
    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
        case next_modules
        case next_tanks
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(ModulesTree.name)] as? String
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.is_default)] as? Bool ?? false)
        self.price_xp = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_xp)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_credit)] as? Int ?? 0)
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.module_id)] as? Int ?? 0)
        self.type = jSON[#keyPath(ModulesTree.type)] as? String

        //#warning("tank_id is expected: self.defaultProfile?.vehicles?.tank_id")
        //#warning("prefix is expected: instead of name, use modules_tree.name")
//        let nextModules = jSON[#keyPath(ModulesTree.next_modules)]
//        (nextModules as? [AnyObject])?.forEach {
//            let moduleTreePK = PKCase()
//            moduleTreePK[.primary] = pkCase[.primary]
//            moduleTreePK[.secondary] = ModulesTree.primaryKey(for: $0)
//            coreDataMapping?.requestSubordinate(for: ModulesTree.self, moduleTreePK, subordinateRequestType: .remote, keyPathPrefix: "modules_tree.", callback: { (managedObject) in
//                if let module = managedObject as? ModulesTree {
//                    self.addToNext_modules(module)
//                    coreDataMapping?.stash(moduleTreePK)
//                }
//            })
//        }

        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            let nextTanksPK = PKCase()
            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0)
            coreDataMapping?.requestSubordinate(for: Vehicles.self, nextTanksPK, subordinateRequestType: .remote, keyPathPrefix: nil, callback: { (managedObject) in
                if let module = managedObject as? ModulesTree {
                    self.addToNext_modules(module)
                    coreDataMapping?.stash(nextTanksPK)
                }
            })
        }
    }
}

extension ModulesTree: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(ModulesTree.module_id)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, nameAlias: self.pkey, predicateFormat: "%K == %@")
    }
}

extension ModulesTree {
    public static func modulesTree(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        json.keys.forEach { (key) in
            guard let moduleTreeJSON = json[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber  else { return }
            guard let modulePK = ModulesTree.primaryKey(for: module_id) else { return }

            let submodulesCase = PKCase()
            submodulesCase[.primary] = modulePK
            submodulesCase[.secondary] = pkCase[.primary]

            coreDataMapping?.requestSubordinate(for: ModulesTree.self, submodulesCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
                coreDataMapping?.mapping(object: newObject, fromJSON: moduleTreeJSON, pkCase: pkCase, forRequest: forRequest)
                callback(newObject)
            }
        }
    }

    public static func nextModules(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectSetCallback ) {
        guard let json = json as? JSON else { return }
        coreDataMapping?.requestSubordinate(for: ModulesTree.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback([newObject])
        }
    }
}
