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

    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //
        switch socket.keypath as? String {
        case #keyPath(Vehicles.default_profile):
            default_profile = pin as? Vehicleprofile
            modules_tree?.doLinking(pin: pin, socket: socket)
        case #keyPath(ModulesTree.next_modules):
            if let modules_tree = pin as? ModulesTree {
                addToModules_tree(modules_tree)
            }
        default:
            assertionFailure("undefiend field \(String(describing: socket))")
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
