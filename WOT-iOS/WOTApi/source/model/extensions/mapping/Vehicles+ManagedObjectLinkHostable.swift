//
//  Vehicles+ManagedObjectMappingProtocol.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Vehicles + ManagedObjectPinProtocol

extension Vehicles: ManagedObjectPinProtocol {}

// MARK: - Vehicles + ManagedObjectSocketProtocol

extension Vehicles: ManagedObjectSocketProtocol {

    public func doLinking(pin element: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        if let default_profile = element as? Vehicleprofile {
            self.default_profile = default_profile
        }
        if let modules_tree = element as? ModulesTree {
            addToModules_tree(modules_tree)
        }
        modules_tree?.doLinking(pin: element, socket: socket)
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
