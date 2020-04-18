//
//  VehicleprofileAmmoPenetration_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileAmmoPenetration: KeypathProtocol {
    @objc
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoPenetration.avg_value),
                #keyPath(VehicleprofileAmmoPenetration.max_value),
                #keyPath(VehicleprofileAmmoPenetration.min_value)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmoPenetration.keypaths()
    }
}

extension VehicleprofileAmmoPenetration {
    public enum FieldKeys: String, CodingKey {
        case min_value
        case avg_value
        case max_valie
    }

    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, linksCallback: OnLinksCallback?) {
        self.min_value = NSDecimalNumber(value: array[0] as? Float ?? 0)
        self.avg_value = NSDecimalNumber(value: array[1] as? Float ?? 0)
        self.max_value = NSDecimalNumber(value: array[2] as? Float ?? 0)
        context.tryToSave()
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, linksCallback: OnLinksCallback?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoPenetration.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromArray: array, into: context, linksCallback: linksCallback)
    }
}
