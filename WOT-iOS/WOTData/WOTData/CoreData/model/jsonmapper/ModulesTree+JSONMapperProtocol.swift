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
                #keyPath(ModulesTree.module_id),
                #keyPath(ModulesTree.price_credit),
                #keyPath(ModulesTree.next_tanks),
                #keyPath(ModulesTree.next_modules)
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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        self.name = jSON[#keyPath(ModulesTree.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.module_id)] as? Int ?? 0)
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.is_default)] as? Bool ?? false)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_credit)] as? Int ?? 0)
        self.price_xp = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_xp)] as? Int ?? 0)

        /*
         *  availableTypes
         *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
         */
        self.type = jSON[#keyPath(ModulesTree.type)] as? String

        var requests = [WOTJSONLink]()

        #warning("remove comment")
//        let nextModuleLinks = self.nextModuleLinks(idents: jSON[#keyPath(ModulesTree.next_modules)] as? [Any]) ?? []
//        requests.append(contentsOf: nextModuleLinks)

        linker?.onLinks(requests)
    }

    private func nextModuleLinks(idents: [Any]?) -> [WOTJSONLink]? {
        var result = [WOTJSONLink?]()
        idents?.forEach {
            if let pk = Module.primaryKey(for: $0 as AnyObject) {
                let link = WOTJSONLink(clazz: Module.self, primaryKeys: [pk], keypathPrefix: nil, completion: self.linkNextModule(_:))
                result.append(link)
            }
        }
        return result.compactMap { $0 }
    }

    private func linkNextModule(_ json: JSON) {
        print(json)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        guard let json = json as? JSON, let entityDescription = ModulesTree.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromJSON: json, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
    }
}

extension ModulesTree {
    public static func set(modulestreeJson json: Any?, externalPK: WOTPrimaryKey?, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        let pkCase = PKCase()
        pkCase[.primary] = externalPK

        let staticKeyArray = json.keys

        staticKeyArray.forEach { (key) in
            guard let moduleTreeJSON = json[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber  else { return }
            guard let pk = ModulesTree.primaryKey(for: module_id) else { return }

            subordinator?.requestNewSubordinate(ModulesTree.self, pkCase) { newObject in
                guard let moduleTree = newObject as? ModulesTree else { return }

                #warning("check nextCase vs pkCase")
                let nextCase = PKCase()
                nextCase[.primary] = pk
                moduleTree.mapping(fromJSON: moduleTreeJSON, pkCase: nextCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
                callback(moduleTree)
            }
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
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, predicateFormat: "%K == %@")
    }
}

extension ModulesTree {
    public static func nextModules(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?, callback: @escaping NSManagedObjectSetCallback ) {
        guard let json = json as? JSON else { return }
        subordinator?.requestNewSubordinate(ModulesTree.self, pkCase) { newObject in
            newObject?.mapping(fromJSON: json, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
            callback([newObject])
        }
    }
}
