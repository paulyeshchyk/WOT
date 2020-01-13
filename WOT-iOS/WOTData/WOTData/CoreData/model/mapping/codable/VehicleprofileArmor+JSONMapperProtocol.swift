//
//  VehicleprofileArmor_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileArmor: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case front
        case sides
        case rear
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: NSDecimalNumber] else { return }
        self.front = jSON["front"]
        self.sides = jSON["sides"]
        self.rear = jSON["rear"]
    }
}
