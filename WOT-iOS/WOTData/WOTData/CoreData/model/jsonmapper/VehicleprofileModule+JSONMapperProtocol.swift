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
    public override func mapping(fromJSON jSON: JSON, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.radio_id = AnyConvertable(#keyPath(VehicleprofileModule.radio_id)).asNSDecimal

        var links: [WOTJSONLink] = .init()
        self.suspension_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.suspension_id)]).asNSDecimal
        if let suspensionPK = Tankchassis.primaryKey(for: suspension_id?.intValue as AnyObject?) {
            if let suspensionLink = WOTJSONLink(clazz: Tankchassis.self, primaryKeys: [suspensionPK], keypathPrefix: nil, completion: { json in //"suspension."
                print(json)
                }) {
                links.append(suspensionLink)
            }
        }

        self.engine_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.engine_id)]).asNSDecimal
        let enginePK = Tankchassis.primaryKey(for: engine_id?.intValue as AnyObject?)

        self.gun_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.gun_id)]).asNSDecimal
        let gunPK = Tankchassis.primaryKey(for: gun_id?.intValue as AnyObject?)

        self.turret_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.turret_id)]).asNSDecimal
        let turretPK = Tankchassis.primaryKey(for: turret_id?.intValue as AnyObject?)

        #warning("refactor from here")
//        let suspensionLink = WOTJSONLink(clazz: VehicleprofileSuspension.self, primaryKeys: [suspensionPK], keypathPrefix: "suspension.") { json in
//            if let tankchassisObject = onSubordinateCreate?(Tankchassis.self, nil) as? Tankchassis {
//                tankchassisObject.mapping(fromJSON: json, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
//                self.tankchassis = tankchassisObject
//            }
//        }

        linksCallback?(links)
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

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileModule.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, externalPK: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileModule {
    public static func module(fromJSON json: Any?, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileModule? {
        guard let json = json as? JSON else { return  nil }
        guard let result = onSubordinateCreate?(VehicleprofileModule.self, externalPK) as? VehicleprofileModule else { return nil }
        result.mapping(fromJSON: json, externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}
