//
//  VehicleprofileGun_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileGun: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileGun.gun_id),
                #keyPath(VehicleprofileGun.move_down_arc),
                #keyPath(VehicleprofileGun.caliber),
                #keyPath(VehicleprofileGun.name),
                #keyPath(VehicleprofileGun.weight),
                #keyPath(VehicleprofileGun.move_up_arc),
                #keyPath(VehicleprofileGun.fire_rate),
                #keyPath(VehicleprofileGun.dispersion),
                #keyPath(VehicleprofileGun.tag),
                #keyPath(VehicleprofileGun.reload_time),
                #keyPath(VehicleprofileGun.tier),
                #keyPath(VehicleprofileGun.aim_time)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileGun.keypaths()
    }
}

extension VehicleprofileGun {
    public enum FieldKeys: String, CodingKey {
        case gun_id
        case move_down_arc
        case caliber
        case name
        case weight
        case move_up_arc
        case fire_rate
        case dispersion
        case tag
        case reload_time
        case tier
        case aim_time
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        self.name = jSON[#keyPath(VehicleprofileGun.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileGun.tag)] as? String
        self.caliber = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.caliber)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.weight)] as? Int ?? 0)
        self.move_down_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.move_down_arc)] as? Int ?? 0)
        self.move_up_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.move_up_arc)] as? Int ?? 0)
        self.fire_rate = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.fire_rate)] as? Double ?? 0)
        self.dispersion = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.dispersion)] as? Double ?? 0)
        self.reload_time = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.reload_time)] as? Double ?? 0)
        self.aim_time = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.aim_time)] as? Double ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileGun.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromJSON: json, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
    }
}

extension VehicleprofileGun {
    public static func gun(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        let tag = jSON[#keyPath(VehicleprofileGun.tag)]
        let pk = VehicleprofileGun.primaryKey(for: tag as AnyObject?)
        let pkCase = PKCase()
        pkCase[.primary] = pk

        subordinator?.requestNewSubordinate(VehicleprofileGun.self, pkCase) { newObject in
            newObject?.mapping(fromJSON: jSON, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
            callback(newObject)
        }
    }
}

extension VehicleprofileGun: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileGun.gun_id)

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
