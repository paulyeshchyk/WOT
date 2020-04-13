//
//  Vehicles_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Vehicles: KeypathProtocol {
    @objc
    public class func keypathsLight() -> [String] {
        return [#keyPath(Vehicles.name),
                #keyPath(Vehicles.short_name),
                #keyPath(Vehicles.type),
                #keyPath(Vehicles.nation),
                #keyPath(Vehicles.tag),
                #keyPath(Vehicles.tier),
                #keyPath(Vehicles.tank_id)
        ]
    }

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
    public override func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
            jsonLinksCallback?(nil)
        }

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

        if let intID = jSON[#keyPath(Vehicles.tank_id)] as? Int {
            let pk = PrimaryKey(name: #keyPath(Vehicles.tank_id), value: String(intID) as AnyObject, predicateFormat: "%K = %d")
            self.default_profile = Vehicleprofile(json: jSON[#keyPath(Vehicles.default_profile)], into: context, parentPrimaryKey: pk, jsonLinksCallback: jsonLinksCallback)

            let module_tree = mapping(modulestreeJson: jSON[#keyPath(Vehicles.modules_tree)], inContext: context, parentPrimaryKey: pk, jsonLinksCallback: jsonLinksCallback)
            module_tree?.forEach {
                self.addToModules_tree($0)
            }
        } else {
            fatalError("wrong id")
        }
    }

    func mapping(modulestreeJson json: Any?, inContext context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) -> [ModulesTree]? {
        guard let moduleTreeJSONArray = json  as? JSON else { return nil }

        var result = [ModulesTree]()
        moduleTreeJSONArray.keys.forEach { (key) in
            guard let moduleTreeJSON = moduleTreeJSONArray[key] as? JSON,
                let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else {
                return
            }

            guard let moduleTree = mapping(moduletreeJson: moduleTreeJSON, module_id: module_id, into: context, parentPrimaryKey: parentPrimaryKey, jsonLinksCallback: jsonLinksCallback) else { return }
            result.append(moduleTree)
        }
        return result
    }

    func mapping(moduletreeJson json: Any?, module_id: NSNumber, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) -> ModulesTree? {
        guard let json = json as? JSON else { return nil }
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ModulesTree.module_id), module_id)
        guard let result = NSManagedObject.findOrCreateObject(forClass: ModulesTree.self, predicate: predicate, context: context) as? ModulesTree else { return nil }

        result.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, jsonLinksCallback: jsonLinksCallback)
        return result
    }
}
