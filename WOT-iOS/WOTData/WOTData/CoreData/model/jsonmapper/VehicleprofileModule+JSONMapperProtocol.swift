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

            let requests = self.nestedRequests(context: context)
            jsonLinksCallback?(requests)
        }

        self.radio_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.radio_id)] as? Int ?? 0)
        self.suspension_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.suspension_id)] as? Int ?? 0)
        self.engine_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.engine_id)] as? Int ?? 0)
        self.gun_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.gun_id)] as? Int ?? 0)
        self.turret_id = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.turret_id)] as? Int ?? 0)
    }

    private func nestedRequests(context: NSManagedObjectContext) -> [WOTJSONLink] {
        let requestRadio = radioRequest(for: self.radio_id, inContext: context)
        let requestEngine = engineRequest(for: self.engine_id, inContext: context)
        let requestGun = gunRequest(for: self.gun_id, inContext: context)
        let requestSuspension = suspensionRequest(for: self.suspension_id, inContext: context)
        let requestTurret = turretRequest(for: self.turret_id, inContext: context)

        return [requestRadio, requestEngine, requestGun, requestSuspension, requestTurret]
    }

    func radioRequest(for radio_id: NSDecimalNumber?, inContext context: NSManagedObjectContext) -> WOTJSONLink {
        return WOTJSONLink(clazz: Tankradios.self, identifier_fieldname: #keyPath(Tankradios.module_id), identifier: radio_id?.stringValue, completion: { [weak self] json in
            guard let self = self else { return }
            guard let module_id = json[#keyPath(Tankradios.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankradios.module_id), module_id)
            guard let tankRadios = NSManagedObject.findOrCreateObject(forClass: Tankradios.self, predicate: predicate, context: context) as? Tankradios else {
                return
            }
            tankRadios.mapping(fromJSON: json, into: context, jsonLinksCallback: nil)
            self.tankradios = tankRadios
        })
    }

    func engineRequest(for engine_id: NSDecimalNumber?, inContext context: NSManagedObjectContext) -> WOTJSONLink {
        return WOTJSONLink(clazz: Tankengines.self, identifier_fieldname: #keyPath(Tankengines.module_id), identifier: engine_id?.stringValue, completion: { [weak self]  json in
            guard let self = self else { return }
            guard let module_id = json[#keyPath(Tankengines.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankengines.module_id), module_id)
            guard let tankEngines = NSManagedObject.findOrCreateObject(forClass: Tankradios.self, predicate: predicate, context: context) as? Tankengines else {
                return
            }
            tankEngines.mapping(fromJSON: json, into: context, jsonLinksCallback: nil)
            self.tankengines = tankEngines
        })
    }

    func gunRequest(for gun_id: NSDecimalNumber?, inContext context: NSManagedObjectContext) -> WOTJSONLink {
        return WOTJSONLink(clazz: Tankguns.self, identifier_fieldname: #keyPath(Tankguns.module_id), identifier: gun_id?.stringValue, completion: { [weak self]  json in
            guard let self = self else { return }
            guard let module_id = json[#keyPath(Tankguns.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankguns.module_id), module_id)
            guard let tankGuns = NSManagedObject.findOrCreateObject(forClass: Tankradios.self, predicate: predicate, context: context) as? Tankguns else {
                return
            }
            tankGuns.mapping(fromJSON: json, into: context, jsonLinksCallback: nil)
            self.tankguns = tankGuns
        })
    }

    func suspensionRequest(for suspension_id: NSDecimalNumber?, inContext context: NSManagedObjectContext) -> WOTJSONLink {
        return WOTJSONLink(clazz: Tankchassis.self, identifier_fieldname: #keyPath(Tankchassis.module_id), identifier: suspension_id?.stringValue, completion: { [weak self]  json in
            guard let self = self else { return }
            guard let module_id = json[#keyPath(Tankchassis.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankchassis.module_id), module_id)
            guard let tankChassis = NSManagedObject.findOrCreateObject(forClass: Tankchassis.self, predicate: predicate, context: context) as? Tankchassis else {
                return
            }
            tankChassis.mapping(fromJSON: json, into: context, jsonLinksCallback: nil)
            self.tankchassis = tankChassis
        })
    }

    func turretRequest(for turret_id: NSDecimalNumber?, inContext context: NSManagedObjectContext) -> WOTJSONLink {
        return WOTJSONLink(clazz: Tankturrets.self, identifier_fieldname: #keyPath(Tankturrets.module_id), identifier: turret_id?.stringValue, completion: { [weak self]  json in
            guard let self = self else { return }
            guard let module_id = json[#keyPath(Tankturrets.module_id)] as? NSNumber else {
                return
            }
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankturrets.module_id), module_id)
            guard let tankTurret = NSManagedObject.findOrCreateObject(forClass: Tankturrets.self, predicate: predicate, context: context) as? Tankturrets else {
                return
            }
            tankTurret.mapping(fromJSON: json, into: context, jsonLinksCallback: nil)
            self.tankturrets = tankTurret
        })
    }
}
