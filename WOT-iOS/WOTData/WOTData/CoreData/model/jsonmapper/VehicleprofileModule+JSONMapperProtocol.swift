//
//  VehicleprofileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

extension VehicleprofileModule: JSONMapperProtocol {
    
    public typealias Fields = Void
    
    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingCompletion?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingCompletion?) {

        defer {
            context.tryToSave()
            

            let requests: [JSONMappingNestedRequest]? = self.nestedRequests(context: context)
            completion?(requests)
        }

        self.radio_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.radio_id)] as? Int ?? 0)
        self.suspension_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.suspension_id)] as? Int ?? 0)
        self.engine_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.engine_id)] as? Int ?? 0)
        self.gun_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.gun_id)] as? Int ?? 0)
        self.turret_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.turret_id)] as? Int ?? 0)
    }
    
    private func nestedRequests(context: NSManagedObjectContext) -> [JSONMappingNestedRequest] {

        let requestRadio = JSONMappingNestedRequest(clazz: Tankradios.self, identifier: self.radio_id, completion: { json in
            guard let tankRadios = Tankradios.insertNewObject(context) as? Tankradios else { return }
            tankRadios.mapping(fromJSON: json, into: context, completion: nil)
            self.tankradios = tankRadios
        })
        let requestEngine = JSONMappingNestedRequest(clazz: Tankengines.self, identifier: self.engine_id, completion: { json in
            guard let tankEngines = Tankengines.insertNewObject(context) as? Tankengines else { return }
            tankEngines.mapping(fromJSON: json, into: context, completion: nil)
            self.tankengines = tankEngines
        })
        let requestGun = JSONMappingNestedRequest(clazz: Tankguns.self, identifier: self.gun_id, completion: { json in
            guard let tankGuns = Tankguns.insertNewObject(context) as? Tankguns else { return }
            tankGuns.mapping(fromJSON: json, into: context, completion: nil)
            self.tankguns = tankGuns
        })
        let requestSuspension = JSONMappingNestedRequest(clazz: Tankchassis.self, identifier: self.suspension_id, completion: { json in
            guard let tankChassis = Tankchassis.insertNewObject(context) as? Tankchassis else { return }
            tankChassis.mapping(fromJSON: json, into: context, completion: nil)
            self.tankchassis = tankChassis
        })
        let requestTurret = JSONMappingNestedRequest(clazz: Tankturrets.self, identifier: self.turret_id, completion: { json in
            guard let tankTurret = Tankturrets.insertNewObject(context) as? Tankturrets else { return }
            tankTurret.mapping(fromJSON: json, into: context, completion: nil)
            self.tankturrets = tankTurret
        })

        return [requestRadio, requestEngine, requestGun, requestSuspension, requestTurret]
    }
}
