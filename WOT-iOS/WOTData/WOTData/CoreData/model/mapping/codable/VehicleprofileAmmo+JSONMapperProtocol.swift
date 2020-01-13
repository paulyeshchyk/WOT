//
//  VehicleprofileAmmo_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmo: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case type
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: Any] else { return }

        self.ammoType = jSON["type"] as? String
    }
}
