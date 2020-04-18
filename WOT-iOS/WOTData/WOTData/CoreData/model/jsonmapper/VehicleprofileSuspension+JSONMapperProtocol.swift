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
        return [#keyPath(VehicleprofileSuspension.tier),
                #keyPath(VehicleprofileSuspension.traverse_speed),
                #keyPath(VehicleprofileSuspension.name),
                #keyPath(VehicleprofileSuspension.load_limit),
                #keyPath(VehicleprofileSuspension.weight),
                #keyPath(VehicleprofileSuspension.steering_lock_angle),
                #keyPath(VehicleprofileSuspension.tag)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileSuspension.keypaths()
    }
}

extension VehicleprofileSuspension {
    public enum FieldKeys: String, CodingKey {
        case tier
        case traverse_speed
        case name
        case load_limit
        case weight
        case steering_lock_angle
        case tag
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(VehicleprofileSuspension.name)] as? String
        self.tag = jSON[#keyPath(VehicleprofileSuspension.tag)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.tier)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.weight)] as? Int ?? 0)
        self.load_limit = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.load_limit)] as? Int ?? 0)
        self.steering_lock_angle = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.steering_lock_angle)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileSuspension.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileSuspension {
    public static func suspension(fromJSON json: Any?, primaryKey pkProfile: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileSuspension? {
        guard let json = json as? JSON else { return  nil }
        guard let result = onSubordinateCreate?(VehicleprofileSuspension.self, pkProfile) as? VehicleprofileSuspension else { return nil }
        result.mapping(fromJSON: json, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }

    public static func linkRequest(for suspension_id: NSDecimalNumber?, parentPrimaryKey: WOTPrimaryKey?, inContext context: NSManagedObjectContext, onSuccess: @escaping (NSManagedObject) -> Void) -> WOTJSONLink? {
        guard let suspension_id = suspension_id else {
            return nil
        }

        var primaryKeys = [WOTPrimaryKey]()
        #warning("wrong key module_id, should be tag")
        let suspensionPK = WOTPrimaryKey(name: "module_id", value: suspension_id, predicateFormat: "%K == %@")
        primaryKeys.append(suspensionPK)
        if let parentPrimaryKey = parentPrimaryKey {
            primaryKeys.append(parentPrimaryKey)
        }

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
