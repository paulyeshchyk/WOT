//
//  Tankguns_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankguns: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankguns.name),
                #keyPath(Tankguns.module_id),
                #keyPath(Tankguns.nation),
                #keyPath(Tankguns.price_credit),
                #keyPath(Tankguns.price_gold),
                #keyPath(Tankguns.rate)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankguns.keypaths()
    }
}

extension Tankguns {
    public enum FieldKeys: String, CodingKey {
        case name
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        self.name = jSON[#keyPath(Tankguns.name)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankguns.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankguns.nation)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankguns.module_id)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankguns.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankguns.price_gold)] as? Int ?? 0)
        self.rate = NSDecimalNumber(value: jSON[#keyPath(Tankguns.rate)] as? Int ?? 0)
        context.tryToSave()
        linksCallback(nil)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        guard let json = json as? JSON, let entityDescription = Tankguns.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
    }
}

extension Tankguns {
    public static func linkRequest(for gun_id: NSDecimalNumber, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        var primaryKeys = [WOTPrimaryKey]()
        let gunsPK = WOTPrimaryKey(name: #keyPath(Tankguns.module_id), value: gun_id, predicateFormat: "%K == %@")
        primaryKeys.append(gunsPK)

        return WOTJSONLink(clazz: Tankguns.self, primaryKeys: primaryKeys, keypathPrefix: nil, completion: { json in
            guard let module_id = json[#keyPath(Tankguns.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankguns.module_id), module_id)
            guard let tankGuns = NSManagedObject.findOrCreateObject(forClass: Tankguns.self, predicate: predicate, context: context) as? Tankguns else {
                return
            }
            onSuccess(tankGuns)
            tankGuns.mapping(fromJSON: json, into: context, parentPrimaryKey: gunsPK, linksCallback: { _ in
                //
            })
        })
    }
}
