//
//  Tankradios_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankradios: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankradios.name),
                #keyPath(Tankradios.module_id),
                #keyPath(Tankradios.distance),
                #keyPath(Tankradios.nation),
                #keyPath(Tankradios.price_credit),
                #keyPath(Tankradios.price_gold)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankradios.keypaths()
    }
}

extension Tankradios {
    public enum FieldKeys: String, CodingKey {
        case name
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(Tankradios.name)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankradios.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankradios.nation)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankradios.module_id)] as? Int ?? 0)
        self.distance = NSDecimalNumber(value: jSON[#keyPath(Tankradios.distance)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankradios.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankradios.price_gold)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankradios.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension Tankradios {
    public static func linkRequest(for radio_id: NSDecimalNumber?, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        guard let radio_id = radio_id else {
            return nil
        }

        var primaryKeys = [WOTPrimaryKey]()
        let radioPK = WOTPrimaryKey(name: #keyPath(Tankradios.module_id), value: radio_id, predicateFormat: "%K == %@")
        primaryKeys.append(radioPK)

        return WOTJSONLink(clazz: Tankradios.self, primaryKeys: primaryKeys, keypathPrefix: nil, completion: { json in

            guard let module_id = json[#keyPath(Tankradios.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankradios.module_id), module_id)
            guard let tankRadios = NSManagedObject.findOrCreateObject(forClass: Tankradios.self, predicate: predicate, context: context) as? Tankradios else {
                return
            }
            onSuccess(tankRadios)
            tankRadios.mapping(fromJSON: json, parentPrimaryKey: radioPK, onSubordinateCreate: nil, linksCallback: { _ in
                //
            })
        })
    }
}

extension Tankradios: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(Tankradios.module_id)

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
