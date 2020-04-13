//
//  Tankturrets_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankturrets: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankturrets.name),
                #keyPath(Tankturrets.module_id),
                #keyPath(Tankturrets.nation),
                #keyPath(Tankturrets.armor_board),
                #keyPath(Tankturrets.armor_fedd),
                #keyPath(Tankturrets.armor_forehead),
                #keyPath(Tankturrets.circular_vision_radius),
                #keyPath(Tankturrets.price_credit),
                #keyPath(Tankturrets.price_gold),
                #keyPath(Tankturrets.rotation_speed)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankturrets.keypaths()
    }
}

extension Tankturrets {
    public enum FieldKeys: String, CodingKey {
        case name
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
            jsonLinksCallback?(nil)
        }

        self.name = jSON[#keyPath(Tankturrets.name)] as? String
        self.nation = jSON[#keyPath(Tankturrets.nation)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.level)] as? Int ?? 0)
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.module_id)] as? Int ?? 0)
        self.armor_board = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.armor_board)] as? Int ?? 0)
        self.armor_fedd = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.armor_fedd)] as? Int ?? 0)
        self.armor_forehead = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.armor_forehead)] as? Int ?? 0)
        self.circular_vision_radius = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.circular_vision_radius)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.price_gold)] as? Int ?? 0)
        self.rotation_speed = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.rotation_speed)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankturrets.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, jsonLinksCallback: jsonLinksCallback)
    }
}

extension Tankturrets {
    public static func linkRequest(for turret_id: NSDecimalNumber, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        var primaryKeys = [PrimaryKey]()
        let turretPK = PrimaryKey(name: #keyPath(Tankturrets.module_id), value: turret_id, predicateFormat: "%K == %@")
        primaryKeys.append(turretPK)

        return WOTJSONLink(clazz: Tankturrets.self, primaryKeys: primaryKeys, keypathPrefix: nil, completion: { json in
            guard let module_id = json[#keyPath(Tankturrets.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankturrets.module_id), module_id)
            guard let tankTurret = NSManagedObject.findOrCreateObject(forClass: Tankturrets.self, predicate: predicate, context: context) as? Tankturrets else {
                return
            }
            onSuccess(tankTurret)
            tankTurret.mapping(fromJSON: json, into: context, parentPrimaryKey: turretPK, jsonLinksCallback: nil)
        })
    }
}
