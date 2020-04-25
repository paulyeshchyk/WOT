//
//  VehicleprofileEngine_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileEngine {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

extension VehicleprofileEngine {
    public static func engine(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }
        let tag = jSON[VehicleprofileEngine.primaryKeyPath()]
        let pk = VehicleprofileEngine.primaryKey(for: tag as AnyObject?)
        let pkCase = PKCase()
        pkCase[.primary] = pk

        coreDataMapping?.requestSubordinate(for: VehicleprofileEngine.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject,fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
