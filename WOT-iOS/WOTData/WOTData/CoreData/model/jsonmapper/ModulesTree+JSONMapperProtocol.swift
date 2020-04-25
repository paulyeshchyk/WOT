//
//  ModulesTree_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension ModulesTree {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        var parents = pkCase.plainParents
        parents.append(self)

        let nextModules = jSON[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let modulePK = PKCase(parentObjects: parents)
            modulePK[.primary] = pkCase[.primary]
            modulePK[.secondary] = Module.primaryIdKey(for: $0)
            coreDataMapping?.requestSubordinate(for: Module.self, modulePK, subordinateRequestType: .remote, keyPathPrefix: nil, callback: { (managedObject) in
                if let module = managedObject as? Module {
                    self.addToNext_modules(module)
                    coreDataMapping?.stash(hint: modulePK)
                }
            })
        }

        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            //parents was not used for next portion of tanks
            let nextTanksPK = PKCase(parentObjects: nil)
            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0)
            coreDataMapping?.requestSubordinate(for: Vehicles.self, nextTanksPK, subordinateRequestType: .remote, keyPathPrefix: nil, callback: { (managedObject) in
                if let tank = managedObject as? Vehicles {
                    self.addToNext_tanks(tank)
                    coreDataMapping?.stash(hint: nextTanksPK)
                }
            })
        }
    }
}

extension ModulesTree {
    public static func modulesTree(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        json.keys.forEach { (key) in
            guard let moduleTreeJSON = json[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber  else { return }
            guard let modulePK = ModulesTree.primaryKey(for: module_id) else { return }

            let submodulesCase = PKCase(parentObjects: pkCase.plainParents)
            submodulesCase[.primary] = modulePK
            submodulesCase[.secondary] = pkCase[.primary]

            coreDataMapping?.requestSubordinate(for: ModulesTree.self, submodulesCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
                coreDataMapping?.mapping(object: newObject, fromJSON: moduleTreeJSON, pkCase: pkCase, forRequest: forRequest)
                callback(newObject)
            }
        }
    }
}
