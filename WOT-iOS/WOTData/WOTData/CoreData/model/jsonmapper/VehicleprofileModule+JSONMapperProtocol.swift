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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.radio_id = AnyConvertable(#keyPath(VehicleprofileModule.radio_id)).asNSDecimal

        var links: [WOTJSONLink] = .init()
        self.suspension_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.suspension_id)]).asNSDecimal
        if let suspensionPK = VehicleprofileSuspension.primaryKey(for: suspension_id?.intValue as AnyObject?) {
            if let suspensionLink = WOTJSONLink(clazz: VehicleprofileSuspension.self, primaryKeys: [suspensionPK], keypathPrefix: nil, completion: { json in //"suspension."
                print(json)
                }) {
                links.append(suspensionLink)
            }
        }

        self.engine_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.engine_id)]).asNSDecimal
        let enginePK = VehicleprofileEngine.primaryKey(for: engine_id?.intValue as AnyObject?)

        self.gun_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.gun_id)]).asNSDecimal
        let gunPK = VehicleprofileGun.primaryKey(for: gun_id?.intValue as AnyObject?)

        self.turret_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.turret_id)]).asNSDecimal
        let turretPK = VehicleprofileTurret.primaryKey(for: turret_id?.intValue as AnyObject?)

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

        var pkCase = PKCase()
        pkCase["primary"] = [parentPrimaryKey].compactMap { $0 }

        self.mapping(fromJSON: json, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileModule {
    public static func module(fromJSON json: Any?, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileModule? {
        guard let json = json as? JSON else { return  nil }

        var pkCase = PKCase()
        pkCase["primary"] = [externalPK].compactMap { $0 }

        guard let result = onSubordinateCreate?(VehicleprofileModule.self, pkCase) as? VehicleprofileModule else { return nil }

        result.mapping(fromJSON: json, pkCase: pkCase, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}
