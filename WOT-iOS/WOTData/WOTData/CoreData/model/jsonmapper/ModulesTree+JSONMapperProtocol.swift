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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
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
            persistentStore?.requestSubordinate(for: Module.self, pkCase: modulePK, subordinateRequestType: .remote, keyPathPrefix: nil, onCreateNSManagedObject: { (managedObject) in
                if let module = managedObject as? Module {
                    self.addToNext_modules(module)
                    persistentStore?.stash(hint: modulePK)
                }
            })
        }

        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            //parents was not used for next portion of tanks
            let nextTanksPK = PKCase(parentObjects: nil)
            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0)
            persistentStore?.requestSubordinate(for: Vehicles.self, pkCase: nextTanksPK, subordinateRequestType: .remote, keyPathPrefix: nil, onCreateNSManagedObject: { (managedObject) in
                if let tank = managedObject as? Vehicles {
                    self.addToNext_tanks(tank)
                    persistentStore?.stash(hint: nextTanksPK)
                }
            })
        }
    }
}

extension ModulesTree {
    public static func modulesTree(fromJSON json: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        json.keys.forEach { (key) in
            guard let moduleTreeJSON = json[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber  else { return }

            let modulePK = ModulesTree.primaryKey(for: module_id)
            let submodulesCase = PKCase(parentObjects: pkCase.plainParents)
            submodulesCase[.primary] = modulePK
            submodulesCase[.secondary] = pkCase[.primary]

            persistentStore?.requestSubordinate(for: ModulesTree.self, pkCase: submodulesCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
                persistentStore?.mapping(object: newObject, fromJSON: moduleTreeJSON, pkCase: pkCase)
                callback(newObject)
            }
        }
    }
}
