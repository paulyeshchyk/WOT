//
//  VehicleprofileTurret_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileTurret: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileTurret.turret_id),
                #keyPath(VehicleprofileTurret.traverse_left_arc),
                #keyPath(VehicleprofileTurret.traverse_speed),
                #keyPath(VehicleprofileTurret.weight),
                #keyPath(VehicleprofileTurret.view_range),
                #keyPath(VehicleprofileTurret.hp),
                #keyPath(VehicleprofileTurret.tier),
                #keyPath(VehicleprofileTurret.name),
                #keyPath(VehicleprofileTurret.tag),
                #keyPath(VehicleprofileTurret.traverse_right_arc)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileTurret.keypaths()
    }
}

extension VehicleprofileTurret {
    public enum FieldKeys: String, CodingKey {
        case turret_id
        case traverse_left_arc
        case traverse_speed
        case weight
        case view_range
        case hp
        case tier
        case name
        case tag
        case traverse_right_arc
    }

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        defer {
            coreDataMapping?.stash(pkCase)
        }
        self.name = jSON[#keyPath(VehicleprofileTurret.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileTurret.tag)] as? String
        self.view_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.view_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.weight)] as? Int ?? 0)
        self.traverse_left_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_left_arc)] as? Int ?? 0)
        self.traverse_right_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_right_arc)] as? Int ?? 0)
        self.traverse_speed = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_speed)] as? Int ?? 0)
        self.hp = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.hp)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileTurret.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        self.mapping(fromJSON: json, pkCase: pkCase, forRequest: forRequest, coreDataMapping: coreDataMapping)
    }
}

extension VehicleprofileTurret {
    public static func turret(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        let tag = jSON[#keyPath(VehicleprofileTurret.tag)]
        let pk = VehicleprofileTurret.primaryKey(for: tag as AnyObject?)
        let pkCase = PKCase()
        pkCase[.primary] = pk

        coreDataMapping?.requestNewSubordinate(VehicleprofileTurret.self, pkCase) { newObject in
            newObject?.mapping(fromJSON: jSON, pkCase: pkCase, forRequest: forRequest, coreDataMapping: coreDataMapping)
            callback(newObject)
        }
    }
}

extension VehicleprofileTurret: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileTurret.turret_id)

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
