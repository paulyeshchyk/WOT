//
//  VehicleprofileAmmo_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileAmmo: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmo.type),
//                #keyPath(VehicleprofileAmmo.stun),
                #keyPath(VehicleprofileAmmo.damage),
                #keyPath(VehicleprofileAmmo.penetration)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmo.keypaths()
    }
}

extension VehicleprofileAmmo {
    public enum FieldKeys: String, CodingKey {
        case type
        case stun
        case damage
        case penetration
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        defer {
            subordinator?.stash()
        }

        self.type = jSON[#keyPath(VehicleprofileAmmo.type)] as? String

        let vehicleprofileAmmoPenetrationCase = PKCase()
        vehicleprofileAmmoPenetrationCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        vehicleprofileAmmoPenetrationCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        VehicleprofileAmmoPenetration.penetration(fromArray: jSON[#keyPath(VehicleprofileAmmo.penetration)], pkCase: vehicleprofileAmmoPenetrationCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
            self.penetration = newObject as? VehicleprofileAmmoPenetration
            subordinator?.stash()
        }

        let vehicleprofileAmmoDamageCase = PKCase()
        vehicleprofileAmmoDamageCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        vehicleprofileAmmoDamageCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        VehicleprofileAmmoDamage.damage(fromArray: jSON[#keyPath(VehicleprofileAmmo.damage)], pkCase: vehicleprofileAmmoDamageCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
            self.damage = newObject as? VehicleprofileAmmoDamage
            subordinator?.stash()
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
        guard let json = json, let entityDescription = VehicleprofileAmmo.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromJSON: json, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
    }
}

extension VehicleprofileAmmo: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileAmmo.type)

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
