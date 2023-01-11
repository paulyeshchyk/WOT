//
//  ModulesTree+ManagedObjectLinkHostable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

import ContextSDK

// MARK: - ModulesTree + ManagedObjectLinkable

extension ModulesTree: ManagedObjectLinkable {}

// MARK: - ModulesTree + ManagedObjectLinkHostable

extension ModulesTree: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, socket: ManagedObjectLinkerSocketProtocol) {
        if let default_profile = element as? Vehicleprofile {
            self.default_profile = default_profile
        }
        if let module = element as? Module {
            if (socket.keypath as? String) == #keyPath(ModulesTree.currentModule) {
                self.currentModule = module
            }
            if (socket.keypath as? String) == #keyPath(ModulesTree.next_modules) {
                addToNext_modules(module)
            }
        }

        if let vehicle = element as? Vehicles {
            if (socket.keypath as? String) == #keyPath(ModulesTree.next_tanks) {
                addToNext_tanks(vehicle)
            }
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {}
}
