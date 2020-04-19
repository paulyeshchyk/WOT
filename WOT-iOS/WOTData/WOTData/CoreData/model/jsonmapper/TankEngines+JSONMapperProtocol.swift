//
//  TankEngines_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankengines: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankengines.name),
                #keyPath(Tankengines.price_gold),
                #keyPath(Tankengines.nation),
                #keyPath(Tankengines.power),
                #keyPath(Tankengines.price_credit),
                #keyPath(Tankengines.fire_starting_chance),
                #keyPath(Tankengines.module_id)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankengines.keypaths()
    }
}

extension Tankengines {
    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case fire_starting_chance
        case level
        case nation
        case power
        case price_credit
        case price_gold
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(Tankengines.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankengines.module_id)] as? Int ?? 0)
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankengines.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankengines.nation)] as? String
        self.fire_starting_chance = NSDecimalNumber(value: jSON[#keyPath(Tankengines.fire_starting_chance)] as? Int ?? 0)
        self.power = NSDecimalNumber(value: jSON[#keyPath(Tankengines.power)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankengines.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankengines.price_gold)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankengines.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, externalPK: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

#warning("add PrimaryKeypathProtocol support")
extension Tankengines {
    public static func linkRequest(for engine_id: NSDecimalNumber, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        var primaryKeys = [WOTPrimaryKey]()
        let enginePK = WOTPrimaryKey(name: #keyPath(Tankengines.module_id), value: engine_id, predicateFormat: "%K == %@")
        primaryKeys.append(enginePK)

        return WOTJSONLink(clazz: Tankengines.self, primaryKeys: primaryKeys, keypathPrefix: nil, completion: { json in

            guard let module_id = json[#keyPath(Tankengines.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankengines.module_id), module_id)
            guard let tankEngines = NSManagedObject.findOrCreateObject(forClass: Tankradios.self, predicate: predicate, context: context) as? Tankengines else {
                return
            }
            onSuccess(tankEngines)
            tankEngines.mapping(fromJSON: json, externalPK: enginePK, onSubordinateCreate: nil, linksCallback: { _ in
                //
            })
        })
    }
}

extension Tankengines: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(Tankengines.module_id)

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
