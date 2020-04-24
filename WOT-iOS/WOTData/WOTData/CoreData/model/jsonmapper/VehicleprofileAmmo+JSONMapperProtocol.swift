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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.type = jSON[#keyPath(VehicleprofileAmmo.type)] as? String

        let vehicleprofileAmmoPenetrationCase = PKCase()
        vehicleprofileAmmoPenetrationCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        vehicleprofileAmmoPenetrationCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        VehicleprofileAmmoPenetration.penetration(fromArray: jSON[#keyPath(VehicleprofileAmmo.penetration)], pkCase: vehicleprofileAmmoPenetrationCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.penetration = newObject as? VehicleprofileAmmoPenetration
            coreDataMapping?.stash(vehicleprofileAmmoPenetrationCase)
        }

        let vehicleprofileAmmoDamageCase = PKCase()
        vehicleprofileAmmoDamageCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        vehicleprofileAmmoDamageCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        VehicleprofileAmmoDamage.damage(fromArray: jSON[#keyPath(VehicleprofileAmmo.damage)], pkCase: vehicleprofileAmmoDamageCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.damage = newObject as? VehicleprofileAmmoDamage
            coreDataMapping?.stash(vehicleprofileAmmoDamageCase)
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        guard let json = json, let entityDescription = VehicleprofileAmmo.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        coreDataMapping?.mapping(object: self, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
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
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, nameAlias: self.pkey, predicateFormat: "%K == %@")
    }
}
