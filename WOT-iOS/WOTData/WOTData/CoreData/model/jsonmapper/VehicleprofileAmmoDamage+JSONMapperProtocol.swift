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
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        self.min_value = NSDecimalNumber(value: array[0] as? Int ?? 0)
        self.avg_value = NSDecimalNumber(value: array[1] as? Int ?? 0)
        self.max_value = NSDecimalNumber(value: array[2] as? Int ?? 0)
        context.tryToSave()
        linksCallback(nil)
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoDamage.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromArray: array, into: context, linksCallback: linksCallback)
    }
}
