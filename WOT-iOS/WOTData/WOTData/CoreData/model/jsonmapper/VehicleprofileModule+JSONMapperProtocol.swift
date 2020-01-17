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
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingCompletion?){

        defer {
            context.tryToSave()
            

            let requests: [JSONMappingNestedRequest]? = nil// self.nestedRequests(context: context)
            completion?(requests)
        }

        self.radio_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.radio_id)] as? Int ?? 0)
        self.suspension_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.suspension_id)] as? Int ?? 0)
        self.engine_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.engine_id)] as? Int ?? 0)
        self.gun_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.gun_id)] as? Int ?? 0)
    }
    
    private func nestedRequests(context: NSManagedObjectContext) -> [JSONMappingNestedRequest] {
        let requestRadio = JSONMappingNestedRequest(clazz: Tankradios.self, identifier: self.radio_id, completion: { json in
            if let tankRadios = Tankradios.insertNewObject(context) as? Tankradios {
                tankRadios.mapping(fromJSON: json, into: context, completion: nil)
                //self.tankRadios = tankRadios
            }
        })
        let requestEngine = JSONMappingNestedRequest(clazz: Tankengines.self, identifier: self.engine_id, completion: { json in
            if let tankEngines = Tankengines.insertNewObject(context) as? Tankengines {
                tankEngines.mapping(fromJSON: json, into: context, completion: nil)
                //self.tankEngines = tankEngines
            }
        })
        let requestGun = JSONMappingNestedRequest(clazz: Tankguns.self, identifier: self.gun_id, completion: { json in
            if let tankGuns = Tankguns.insertNewObject(context) as? Tankguns {
                tankGuns.mapping(fromJSON: json, into: context, completion: nil)
                //self.tankGuns = tankGuns
            }
        })
        
        return [requestRadio, requestEngine, requestGun]
    }
}
