//
//  ModulesTree_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension ModulesTree: JSONMapperProtocol {

    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: Any] else { return }

        self.module_id = NSDecimalNumber(value: jSON[WOTApiKeys.module_id] as? Int ?? 0)
        self.name = jSON[WOTApiKeys.name] as? String
        
        self.price_credit = jSON[WOTApiKeys.price_credit] as? NSDecimalNumber
        self.price_xp = jSON[WOTApiKeys.price_xp] as? NSDecimalNumber
        self.is_default = jSON[WOTApiKeys.is_default] as? NSNumber
        
        /**
         *  availableTypes
         *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
         */
        self.type = jSON[WOTApiKeys.type] as? String
    }
}
