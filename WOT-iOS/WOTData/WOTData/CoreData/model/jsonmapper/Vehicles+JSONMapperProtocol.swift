//
//  Vehicles_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Vehicles: JSONMapperProtocol {
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
    public func mapping(fromArray jSON: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
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
        self.default_profile = Vehicleprofile(json: jSON[#keyPath(Vehicles.default_profile)], into: context, jsonLinksCallback: jsonLinksCallback)

        let module_tree = mapping(modulestreeJson: jSON[#keyPath(Vehicles.modules_tree)], inContext: context, jsonLinksCallback: jsonLinksCallback)
        module_tree?.forEach {
            self.addToModules_tree($0)
        }
    }

    func mapping(modulestreeJson json: Any?, inContext context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) -> [ModulesTree]? {
        guard let moduleTreeJSONArray = json  as? JSON else { return nil }

        var result = [ModulesTree]()
        moduleTreeJSONArray.keys.forEach { (key) in
            guard let moduleTreeJSON = moduleTreeJSONArray[key] as? JSON,
                let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else {
                return
            }

            guard let moduleTree = mapping(moduletreeJson: moduleTreeJSON, module_id: module_id, into: context, jsonLinksCallback: jsonLinksCallback) else { return }
            result.append(moduleTree)
        }
        return result
    }

    func mapping(moduletreeJson json: Any?, module_id: NSNumber, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) -> ModulesTree? {
        guard let json = json as? JSON else { return nil }
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ModulesTree.module_id), module_id)
        guard let result = NSManagedObject.findOrCreateObject(forClass: ModulesTree.self, predicate: predicate, context: context) as? ModulesTree else { return nil }

        result.mapping(fromJSON: json, into: context, jsonLinksCallback: jsonLinksCallback)
        return result
    }
}
