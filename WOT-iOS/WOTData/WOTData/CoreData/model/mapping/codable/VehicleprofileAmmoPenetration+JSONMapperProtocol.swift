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
    public func mapping(from jSON: Any){
        guard let array = jSON as? [NSNumber] else {
            return
        }
        self.min_value = NSDecimalNumber(value: array[0].floatValue)
        self.avg_value = NSDecimalNumber(value: array[1].floatValue)
        self.max_value = NSDecimalNumber(value: array[2].floatValue)
    }

}
