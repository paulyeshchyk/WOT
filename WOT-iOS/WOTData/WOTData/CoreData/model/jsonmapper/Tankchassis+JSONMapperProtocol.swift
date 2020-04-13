//
//  Tankchassis_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankchassis: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankchassis.name),
                #keyPath(Tankchassis.module_id),
                #keyPath(Tankchassis.max_load),
                #keyPath(Tankchassis.nation),
                #keyPath(Tankchassis.price_credit),
                #keyPath(Tankchassis.price_gold),
                #keyPath(Tankchassis.rotation_speed)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankchassis.keypaths()
    }
}

extension Tankchassis {
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

        self.name = jSON[#keyPath(Tankchassis.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankchassis.module_id)] as? Int ?? 0)
        self.level = jSON[#keyPath(Tankchassis.level)] as? NSDecimalNumber
        self.nation = jSON[#keyPath(Tankchassis.nation)] as? String
        self.max_load = jSON[#keyPath(Tankchassis.max_load)] as? NSNumber
        self.price_credit = jSON[#keyPath(Tankchassis.price_credit)] as? NSDecimalNumber
        self.price_gold = jSON[#keyPath(Tankchassis.price_gold)] as? NSDecimalNumber
        self.rotation_speed = jSON[#keyPath(Tankchassis.rotation_speed)] as? NSDecimalNumber
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankchassis.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, jsonLinksCallback: jsonLinksCallback)
    }
}

extension Tankchassis {
    public static func linkRequest(for suspension_id: NSDecimalNumber?, parentPrimaryKey: PrimaryKey, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        guard let suspension_id = suspension_id else {
            return nil
        }

        var primaryKeys = [PrimaryKey]()
        let suspensionPK = PrimaryKey(name: #keyPath(Tankchassis.module_id), value: suspension_id, predicateFormat: "%K == %@")
        primaryKeys.append(suspensionPK)
        primaryKeys.append(parentPrimaryKey)

        return WOTJSONLink(clazz: Tankchassis.self, primaryKeys: primaryKeys, keypathPrefix: nil, completion: { json in
            guard let module_id = json[#keyPath(Tankchassis.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankchassis.module_id), module_id)
            guard let tankChassis = NSManagedObject.findOrCreateObject(forClass: Tankchassis.self, predicate: predicate, context: context) as? Tankchassis else {
                return
            }
            onSuccess(tankChassis)
            tankChassis.mapping(fromJSON: json, into: context, parentPrimaryKey: suspensionPK, jsonLinksCallback: nil)
        })
    }
}
