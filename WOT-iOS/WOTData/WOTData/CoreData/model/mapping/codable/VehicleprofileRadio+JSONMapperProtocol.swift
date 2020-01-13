//
//  VehicleprofileRadio_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileRadio: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case tier
        case signal_range
        case tag
        case weight
        case name
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: Any] else { return }
        self.tier = jSON["tier"] as? NSDecimalNumber
        self.signal_range = jSON["signal_range"] as? NSDecimalNumber
        self.tag = jSON["tag"] as? String
        self.weight = jSON["weight"] as? NSDecimalNumber
        self.name = jSON["name"] as? String
    }
}

