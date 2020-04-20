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
        return [#keyPath(VehicleprofileSuspension.suspension_id),
                #keyPath(VehicleprofileSuspension.tier),
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
        case suspension_id
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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
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

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromJSON: json, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileSuspension {
    public static func suspension(fromJSON jSON: Any?, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileSuspension? {
        guard let jSON = jSON as? JSON else { return  nil }

        let tag = jSON[#keyPath(VehicleprofileSuspension.tag)]
        let pk = VehicleprofileSuspension.primaryKey(for: tag as AnyObject?)

        let pkCase = PKCase()
        pkCase[.primary] = pk

        guard let result = onSubordinateCreate?(VehicleprofileSuspension.self, pkCase) as? VehicleprofileSuspension else {
            fatalError("Suspension is not created")
        }

        result.mapping(fromJSON: jSON, pkCase: pkCase, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
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

            let pkCase = PKCase()
            pkCase[.primary] = suspensionPK

            suspension.mapping(fromJSON: json, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: { json in
                print(json)
            })
        })
    }
}

extension VehicleprofileSuspension: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileSuspension.suspension_id)

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
