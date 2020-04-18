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
        return [#keyPath(VehicleprofileRadio.tier),
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
        case tier
        case signal_range
        case tag
        case weight
        case name
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(VehicleprofileRadio.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileRadio.tag)] as? String
        self.signal_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.signal_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.weight)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileRadio.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileRadio {
    public static func radio(fromJSON json: Any?, primaryKey pkProfile: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileRadio? {
        guard let json = json as? JSON else { return  nil }
        guard let result = onSubordinateCreate?(VehicleprofileRadio.self, pkProfile) as? VehicleprofileRadio else { return nil }
        result.mapping(fromJSON: json, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}
