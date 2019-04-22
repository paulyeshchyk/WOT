//
//  VehicleprofileAmmoDamage_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoDamage: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case min_value
        case avg_value
        case max_value
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: [AnyHashable: Any]){
        guard let array = jSON as? [NSDecimalNumber] else {
            return
        }
        self.min_value = array[0];
        self.avg_value = array[1];
        self.max_value = array[2];
    }
}
