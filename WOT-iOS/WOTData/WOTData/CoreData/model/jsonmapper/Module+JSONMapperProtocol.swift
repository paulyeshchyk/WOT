//
//  VehicleprofileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension Module {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(Module.name)] as? String
        self.nation = jSON[#keyPath(Module.nation)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(Module.tier)] as? Int ?? 0)
        self.type = jSON[#keyPath(Module.type)] as? String
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Module.price_credit)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(Module.weight)] as? Int ?? 0)
//        self.module_id = AnyConvertable(jSON[#keyPath(Module.module_id)]).asNSDecimal
        self.image = jSON[#keyPath(Module.image)] as? String
        /*
         let nextTanksPK = PKCase()
         nextTanksPK[.primary] = Vehicles.primaryKey(for: $0)
         coreDataMapping?.requestSubordinate(for: Vehicles.self, nextTanksPK, subordinateRequestType: .remote, keyPathPrefix: nil, callback: { (managedObject) in
             if let module = managedObject as? ModulesTree {
                 self.addToNext_modules(module)
                 coreDataMapping?.stash(nextTanksPK)
             }
         })

         */
    }
}

extension Module {
    public static func module(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.requestSubordinate(for: Module.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
