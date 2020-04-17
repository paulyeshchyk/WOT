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
        return [#keyPath(VehicleprofileAmmo.type)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmo.keypaths()
    }
}

extension VehicleprofileAmmo {
    public enum FieldKeys: String, CodingKey {
        case type
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        self.type = jSON[#keyPath(VehicleprofileAmmo.type)] as? String
        self.penetration = VehicleprofileAmmoPenetration(array: jSON[#keyPath(VehicleprofileAmmo.penetration)], into: context, linksCallback: linksCallback)
        self.damage = VehicleprofileAmmoDamage(array: jSON[#keyPath(VehicleprofileAmmo.damage)], into: context, linksCallback: linksCallback)
        context.tryToSave()
        linksCallback(nil)
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        guard let json = json, let entityDescription = VehicleprofileAmmo.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
    }
}
