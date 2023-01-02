//
//  Vehicles+ManagedObjectMappingProtocol.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

extension Vehicles: ManagedObjectLinkable {}

extension Vehicles: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol) {
        if let default_profile = element as? Vehicleprofile {
            self.default_profile = default_profile
        }
        if let modules_tree = element as? ModulesTree {
            addToModules_tree(modules_tree)
        }
        modules_tree?.doLinking(element, anchor: anchor)
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
