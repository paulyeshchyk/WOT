//
//  VehicleprofileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

extension VehicleprofileModule {
    public typealias Fields = Void

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.radio_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.radio_id)]).asNSDecimal
        self.suspension_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.suspension_id)]).asNSDecimal
        self.engine_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.engine_id)]).asNSDecimal
        self.gun_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.gun_id)]).asNSDecimal
        self.turret_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.turret_id)]).asNSDecimal

        #warning("refactor from here")

//        var links: [WOTJSONLink] = .init()
//        if let suspensionPK = VehicleprofileSuspension.primaryKey(for: suspension_id?.intValue as AnyObject?) {
//            if let suspensionLink = WOTJSONLink(clazz: VehicleprofileSuspension.self, primaryKeys: [suspensionPK], keypathPrefix: nil, completion: { json in //"suspension."
//                print(json)
//                }) {
//                links.append(suspensionLink)
//            }
//        }
//
//        let enginePK = VehicleprofileEngine.primaryKey(for: engine_id?.intValue as AnyObject?)
//
//        let gunPK = VehicleprofileGun.primaryKey(for: gun_id?.intValue as AnyObject?)
//
//        let turretPK = VehicleprofileTurret.primaryKey(for: turret_id?.intValue as AnyObject?)

//        let suspensionLink = WOTJSONLink(clazz: VehicleprofileSuspension.self, primaryKeys: [suspensionPK], keypathPrefix: "suspension.") { json in
//            if let tankchassisObject = subordinator?(Tankchassis.self, nil) as? Tankchassis {
//                coreDataMapping?.mapping(object: tankchassisObject, fromJSON: json, parentPrimaryKey: nil, subordinator: subordinator)
//                self.tankchassis = tankchassisObject
//            }
//        }
    }

    private func nestedRequests(parentPrimaryKey: WOTPrimaryKey?) -> [WOTJSONLink] {
//        let requestRadio = VehicleprofileRadio.linkRequest(for: self.radio_id, inContext: nil) { [weak self] result in
//            self?.tankradios = result as? VehicleprofileRadio
//        }
//        let requestEngine = Tankengines.linkRequest(for: self.engine_id, inContext: context) { [weak self] result in
//            self?.tankengines = result as? Tankengines
//        }
//        let requestGun = Tankguns.linkRequest(for: self.gun_id, inContext: context) { [weak self] result in
//            self?.tankguns = result as? Tankguns
//        }
//        let requestSuspension = VehicleprofileSuspension.linkRequest(for: self.suspension_id, parentPrimaryKey: parentPrimaryKey, inContext: context) { [weak self] result in
//            self?.tankchassis = result as? Tankchassis
//        }
//        let requestTurret = Tankturrets.linkRequest(for: self.turret_id, inContext: context) { [weak self] result in
//            self?.tankturrets = result as? Tankturrets
//        }

        return [/*requestSuspension, requestRadio, requestEngine, requestGun, requestTurret*/].compactMap { $0 }
    }
}

extension VehicleprofileModule {
    public static func module(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.pullLocalSubordinate(for: VehicleprofileModule.self, pkCase) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
