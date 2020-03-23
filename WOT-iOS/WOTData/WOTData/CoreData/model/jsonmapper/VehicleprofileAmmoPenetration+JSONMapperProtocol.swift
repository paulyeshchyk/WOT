//
//  VehicleprofileAmmoPenetration_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoPenetration: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case min_value
        case avg_value
        case max_valie
    }

    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
        }

        self.min_value = NSDecimalNumber(value: array[0] as? Float ?? 0)
        self.avg_value = NSDecimalNumber(value: array[1] as? Float ?? 0)
        self.max_value = NSDecimalNumber(value: array[2] as? Float ?? 0)
    }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){}
}
