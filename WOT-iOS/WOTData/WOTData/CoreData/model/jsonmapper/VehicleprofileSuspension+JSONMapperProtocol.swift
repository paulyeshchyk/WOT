//
//  VehicleprofileSuspension_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileSuspension: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileSuspension.name),
                #keyPath(VehicleprofileSuspension.weight),
                #keyPath(VehicleprofileSuspension.load_limit),
                #keyPath(VehicleprofileSuspension.tag),
                #keyPath(VehicleprofileSuspension.tier)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileSuspension.keypaths()
    }
}

extension VehicleprofileSuspension {
    public enum FieldKeys: String, CodingKey {
        case name
        case weight
        case load_limit
        case tag
        case tier
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(VehicleprofileSuspension.name)] as? String
        self.tag = jSON[#keyPath(VehicleprofileSuspension.tag)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.tier)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.weight)] as? Int ?? 0)
        self.load_limit = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.load_limit)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileSuspension.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileSuspension {
    public static func linkRequest(for suspension_id: NSDecimalNumber?, parentPrimaryKey: WOTPrimaryKey, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        guard let suspension_id = suspension_id else {
            return nil
        }

        var primaryKeys = [WOTPrimaryKey]()
        #warning("wrong key module_id, should be tag")
        let suspensionPK = WOTPrimaryKey(name: "module_id", value: suspension_id, predicateFormat: "%K == %@")
        primaryKeys.append(suspensionPK)
        primaryKeys.append(parentPrimaryKey)

        return WOTJSONLink(clazz: VehicleprofileSuspension.self, primaryKeys: primaryKeys, keypathPrefix: "suspension.", completion: { json in
            guard let suspension = NSManagedObject.findOrCreateObject(forClass: VehicleprofileSuspension.self, predicate: suspensionPK.predicate, context: context) as? VehicleprofileSuspension else {
                return
            }
            onSuccess(suspension)
            suspension.mapping(fromJSON: json, parentPrimaryKey: suspensionPK, onSubordinateCreate: nil, linksCallback: { _ in
                //
            })
        })
    }
}

extension VehicleprofileSuspension {
    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", #keyPath(VehicleprofileSuspension.tag), ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: #keyPath(VehicleprofileSuspension.tag), value: ident as AnyObject, predicateFormat: "%K == %@")
    }
}
