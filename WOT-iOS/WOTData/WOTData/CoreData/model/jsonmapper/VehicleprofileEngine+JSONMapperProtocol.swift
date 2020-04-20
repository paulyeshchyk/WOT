//
//  VehicleprofileEngine_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileEngine: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileEngine.engine_id),
                #keyPath(VehicleprofileEngine.name),
                #keyPath(VehicleprofileEngine.power),
                #keyPath(VehicleprofileEngine.weight),
                #keyPath(VehicleprofileEngine.tag),
                #keyPath(VehicleprofileEngine.fire_chance),
                #keyPath(VehicleprofileEngine.tier)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileEngine.keypaths()
    }
}

extension VehicleprofileEngine {
    public enum FieldKeys: String, CodingKey {
        case engine_id
        case name
        case power
        case weight
        case tag
        case fire_chance
        case tier
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(VehicleprofileEngine.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.tier)]  as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileEngine.tag)] as? String
        self.power = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.power)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.weight)]  as? Int ?? 0)
        self.fire_chance = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.fire_chance)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileEngine.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        var pkCase = PKCase()
        pkCase["primary"] = [parentPrimaryKey].compactMap { $0 }

        self.mapping(fromJSON: json, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileEngine {
    public static func engine(fromJSON jSON: Any?, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileEngine? {
        guard let jSON = jSON as? JSON else { return  nil }
        let tag = jSON[#keyPath(VehicleprofileEngine.tag)]
        let pk = VehicleprofileEngine.primaryKey(for: tag as AnyObject?)
        var pkCase = PKCase()
        pkCase["primary"] = [pk].compactMap { $0 }

        guard let result = onSubordinateCreate?(VehicleprofileEngine.self, pkCase) as? VehicleprofileEngine else {
            fatalError("Engine not created")
        }

        result.mapping(fromJSON: jSON, pkCase: pkCase, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

extension VehicleprofileEngine: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileEngine.engine_id)

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
