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
        return [#keyPath(VehicleprofileGun.move_down_arc),
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
    public override func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
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
        context.tryToSave()
        linksCallback(nil)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileGun.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
    }
}
