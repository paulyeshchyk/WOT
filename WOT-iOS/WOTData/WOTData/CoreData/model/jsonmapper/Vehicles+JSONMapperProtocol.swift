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
    public func mapping(fromArray jSON: [Any], into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?){
        
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
        
        if let moduleTreeJSONArray = jSON[#keyPath(Vehicles.modules_tree)] as? JSON {
            moduleTreeJSONArray.keys.forEach { (key) in
                guard let moduleTreeJSON = moduleTreeJSONArray[key] as? JSON else {
                    return
                }
                    
                let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as! NSNumber
                let predicate = NSPredicate(format: "%K == %@", #keyPath(ModulesTree.module_id), module_id)
                if let moduleTree = NSManagedObject.findOrCreateObject(forClass:ModulesTree.self, predicate: predicate, context: context) as? ModulesTree {
                    moduleTree.mapping(fromJSON: moduleTreeJSON, into: context, completion: completion)
                    self.addToModules_tree(moduleTree)
                }
            }
            
        }

        if let profile = Vehicleprofile.insertNewObject(context) as? Vehicleprofile {
            if let json = jSON[#keyPath(Vehicles.default_profile)] as? JSON {
                profile.mapping(fromJSON: json, into: context, completion: completion)
            }
            self.default_profile = profile
        }
    }
}
