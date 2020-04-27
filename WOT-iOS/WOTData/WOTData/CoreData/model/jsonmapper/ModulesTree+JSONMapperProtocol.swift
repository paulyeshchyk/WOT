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
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        var parents = pkCase.plainParents
        parents.append(self)

        let nextModules = jSON[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let modulePK = RemotePKCase(parentObjects: parents)
            modulePK[.primary] = pkCase[.primary]
            modulePK[.secondary] = Module.primaryIdKey(for: $0)
            persistentStore?.remoteSubordinate(for: Module.self, pkCase: modulePK, keypathPrefix: nil, onCreateNSManagedObject: { (managedObject) in
                if let module = managedObject as? Module {
                    self.addToNext_modules(module)
                    persistentStore?.stash(hint: modulePK)
                }
            })
        }

        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            //parents was not used for next portion of tanks
            let nextTanksPK = RemotePKCase(parentObjects: nil)
            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0)
            persistentStore?.remoteSubordinate(for: Vehicles.self, pkCase: nextTanksPK, keypathPrefix: nil, onCreateNSManagedObject: { (managedObject) in
                if let tank = managedObject as? Vehicles {
                    self.addToNext_tanks(tank)
                    persistentStore?.stash(hint: nextTanksPK)
                }
            })
        }
    }
}
