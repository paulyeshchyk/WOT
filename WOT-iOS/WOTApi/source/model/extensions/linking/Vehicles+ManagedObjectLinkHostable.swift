//
//  Vehicles+ManagedObjectMappingProtocol.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Vehicles + ManagedObjectPinProtocol

extension Vehicles: ManagedObjectPinProtocol {}

// MARK: - Vehicles + ManagedObjectPlugProtocol

extension Vehicles: ManagedObjectPlugProtocol {

    public func plug(pin: ManagedObjectPinProtocol, intoSocket: JointSocketProtocol) {
        //
        switch intoSocket.keypath as? String {
        case #keyPath(Vehicles.default_profile):
            default_profile = pin as? Vehicleprofile
            modules_tree?.plug(pin: pin, intoSocket: intoSocket)
        case #keyPath(ModulesTree.next_modules):
            if let modules_tree = pin as? ModulesTree {
                addToModules_tree(modules_tree)
            }
        default:
            assertionFailure("undefiend field \(String(describing: intoSocket))")
        }
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
