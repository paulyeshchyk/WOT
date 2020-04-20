//
//  VehicleprofileRadio_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileRadio: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileRadio.radio_id),
                #keyPath(VehicleprofileRadio.tier),
                #keyPath(VehicleprofileRadio.signal_range),
                #keyPath(VehicleprofileRadio.tag),
                #keyPath(VehicleprofileRadio.weight),
                #keyPath(VehicleprofileRadio.name)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileRadio.keypaths()
    }
}

extension VehicleprofileRadio {
    public enum FieldKeys: String, CodingKey {
        case radio_id
        case tier
        case signal_range
        case tag
        case weight
        case name
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(VehicleprofileRadio.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileRadio.tag)] as? String
        self.signal_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.signal_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.weight)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileRadio.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        var pkCase = PKCase()
        pkCase["primary"] = [parentPrimaryKey].compactMap {$0}

        self.mapping(fromJSON: json, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileRadio {
    public static func radio(fromJSON jSON: Any?, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileRadio? {
        guard let jSON = jSON as? JSON else { return  nil }

        let tag = jSON[#keyPath(VehicleprofileRadio.tag)]
        let pk = VehicleprofileRadio.primaryKey(for: tag as AnyObject?)

        var pkCase = PKCase()
        pkCase["primary"] = [pk].compactMap { $0 }

        guard let result = onSubordinateCreate?(VehicleprofileRadio.self, pkCase) as? VehicleprofileRadio else {
            fatalError("radio is not created")
        }

        result.mapping(fromJSON: jSON, pkCase: pkCase, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

extension VehicleprofileRadio: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileRadio.radio_id)

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
