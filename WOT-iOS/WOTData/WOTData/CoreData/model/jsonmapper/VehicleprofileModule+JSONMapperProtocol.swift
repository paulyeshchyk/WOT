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
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()

            let requests = self.nestedRequests(context: context, jsonLinksCallback: jsonLinksCallback)
            jsonLinksCallback?(requests)
        }

        let jsonRadioId = jSON[#keyPath(VehicleprofileModule.radio_id)] as? Int
        self.radio_id = (jsonRadioId != nil) ? NSDecimalNumber(value: jsonRadioId!) : nil

        let chassisId = jSON[#keyPath(VehicleprofileModule.suspension_id)] as? Int
        self.suspension_id = (chassisId != nil) ? NSDecimalNumber(value: chassisId!) : nil

        let engineId = jSON[#keyPath(VehicleprofileModule.engine_id)] as? Int
        self.engine_id = (engineId != nil) ? NSDecimalNumber(value: engineId!) : nil

        let gunId = jSON[#keyPath(VehicleprofileModule.gun_id)] as? Int
        self.gun_id = (gunId != nil) ? NSDecimalNumber(value: gunId!) : nil

        let turretId = jSON[#keyPath(VehicleprofileModule.turret_id)] as? Int
        self.turret_id = ( turretId != nil ) ? NSDecimalNumber(value: turretId!) : nil
    }

    private func nestedRequests(context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) -> [WOTJSONLink] {
//        let requestRadio = Tankradios.linkRequest(for: self.radio_id, inContext: context) { [weak self] result in
//            self?.tankradios = result as? Tankradios
//        }
//        let requestEngine = Tankengines.linkRequest(for: self.engine_id, inContext: context) { [weak self] result in
//            self?.tankengines = result as? Tankengines
//        }
//        let requestGun = Tankguns.linkRequest(for: self.gun_id, inContext: context) { [weak self] result in
//            self?.tankguns = result as? Tankguns
//        }
        let requestSuspension = Tankchassis.linkRequest(for: self.suspension_id, inContext: context) { [weak self] result in
            self?.tankchassis = result as? Tankchassis
        }
//        let requestTurret = Tankturrets.linkRequest(for: self.turret_id, inContext: context) { [weak self] result in
//            self?.tankturrets = result as? Tankturrets
//        }

        return [requestSuspension/*, requestRadio, requestEngine, requestGun, requestTurret*/].compactMap { $0 }
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileModule.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, jsonLinksCallback: jsonLinksCallback)
    }
}
