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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(VehicleprofileSuspension.name)] as? String
        self.tag = jSON[#keyPath(VehicleprofileSuspension.tag)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.tier)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.weight)] as? Int ?? 0)
        self.load_limit = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.load_limit)] as? Int ?? 0)
        self.steering_lock_angle = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.steering_lock_angle)] as? Int ?? 0)
    }
}

extension VehicleprofileSuspension {
    public static func suspension(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        let tag = jSON[VehicleprofileSuspension.primaryKeyPath()]
        let pk = VehicleprofileSuspension.primaryKey(for: tag as AnyObject?)

        let pkCase = PKCase()
        pkCase[.primary] = pk

        coreDataMapping?.requestSubordinate(for: VehicleprofileSuspension.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
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
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, nameAlias: self.pkey, predicateFormat: "%K == %@")
    }
}
