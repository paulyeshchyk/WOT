//
//  VehicleprofileSuspension_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileSuspension: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case name
        case weight
        case load_limit
        case tag
        case tier
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: [AnyHashable: Any]){
        self.name = jSON["name"] as? String
        self.weight = jSON["weight"] as? NSDecimalNumber
        self.load_limit = jSON["load_limit"] as? NSDecimalNumber
        self.tag = jSON["tag"] as? String
        self.tier = jSON["tier"] as? NSDecimalNumber

    }
}
