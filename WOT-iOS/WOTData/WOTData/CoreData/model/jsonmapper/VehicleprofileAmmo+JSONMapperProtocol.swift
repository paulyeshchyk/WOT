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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, subordinator: CoreDataSubordinatorProtocol?, linksCallback: OnLinksCallback?) {
        self.type = jSON[#keyPath(VehicleprofileAmmo.type)] as? String
        VehicleprofileAmmoPenetration.penetration(fromArray: jSON[#keyPath(VehicleprofileAmmo.penetration)],primaryKey: nil, subordinator: subordinator, linksCallback: linksCallback) { newObject in
            self.penetration = newObject as? VehicleprofileAmmoPenetration
        }
        VehicleprofileAmmoDamage.damage(fromArray: jSON[#keyPath(VehicleprofileAmmo.damage)], primaryKey: nil, subordinator: subordinator, linksCallback: linksCallback) { newObject in
            self.damage = newObject as? VehicleprofileAmmoDamage
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json, let entityDescription = VehicleprofileAmmo.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromJSON: json, pkCase: pkCase, subordinator: nil, linksCallback: linksCallback)
    }
}
