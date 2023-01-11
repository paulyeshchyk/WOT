//
//  ModulesTree+ManagedObjectLinkHostable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

import ContextSDK

// MARK: - ModulesTree + ManagedObjectPinProtocol

extension ModulesTree: ManagedObjectPinProtocol {}

// MARK: - ModulesTree + ManagedObjectSocketProtocol

extension ModulesTree: ManagedObjectSocketProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //

        switch socket.keypath as? String {
        case #keyPath(ModulesTree.default_profile):
            default_profile = pin as? Vehicleprofile
        case #keyPath(ModulesTree.currentModule):
            currentModule = pin as? Module
        case #keyPath(ModulesTree.next_modules):
            if let module = pin as? Module {
                addToNext_modules(module)
            }
        case #keyPath(ModulesTree.next_tanks):
            if let vehicle = pin as? Vehicles {
                addToNext_tanks(vehicle)
            }
        default:
            assertionFailure("undefiend field \(String(describing: socket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {}
}
