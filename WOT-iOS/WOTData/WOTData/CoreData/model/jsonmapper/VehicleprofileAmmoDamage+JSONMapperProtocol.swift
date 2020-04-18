//
//  VehicleprofileAmmoDamage_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileAmmoDamage: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoDamage.avg_value),
                #keyPath(VehicleprofileAmmoDamage.max_value),
                #keyPath(VehicleprofileAmmoDamage.min_value)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmoDamage.keypaths()
    }
}

extension VehicleprofileAmmoDamage {
    public enum FieldKeys: String, CodingKey {
        case min_value
        case avg_value
        case max_value
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromArray array: [Any], parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.min_value = NSDecimalNumber(value: array[0] as? Int ?? 0)
        self.avg_value = NSDecimalNumber(value: array[1] as? Int ?? 0)
        self.max_value = NSDecimalNumber(value: array[2] as? Int ?? 0)
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoPenetration.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromArray: array, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileAmmoDamage {
    public static func damage(fromArray array: Any?, primaryKey pkProfile: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileAmmoDamage? {
        guard let array = array as? [Any] else { return  nil }
        guard let result = onSubordinateCreate?(VehicleprofileAmmoDamage.self, pkProfile) as? VehicleprofileAmmoDamage else { return nil }
        result.mapping(fromArray: array, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

#warning("add PrimaryKeypathProtocol support")
