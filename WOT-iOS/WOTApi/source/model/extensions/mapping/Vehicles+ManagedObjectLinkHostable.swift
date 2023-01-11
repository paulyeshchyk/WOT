//
//  Vehicles+ManagedObjectMappingProtocol.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Vehicles + ManagedObjectLinkable

extension Vehicles: ManagedObjectLinkable {}

// MARK: - Vehicles + ManagedObjectLinkHostable

extension Vehicles: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, socket: ManagedObjectLinkerSocketProtocol) {
        if let default_profile = element as? Vehicleprofile {
            self.default_profile = default_profile
        }
        if let modules_tree = element as? ModulesTree {
            addToModules_tree(modules_tree)
        }
        modules_tree?.doLinking(element, socket: socket)
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }
}
