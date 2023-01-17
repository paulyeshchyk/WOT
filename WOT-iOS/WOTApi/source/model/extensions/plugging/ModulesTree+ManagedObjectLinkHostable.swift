//
//  ModulesTree+ManagedObjectLinkHostable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - ModulesTree + ManagedObjectPinProtocol

extension ModulesTree: ManagedObjectPinProtocol {}

// MARK: - ModulesTree + ManagedObjectPlugProtocol

extension ModulesTree: ManagedObjectPlugProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func plug(pin: ManagedObjectPinProtocol?, intoSocket: JointSocketProtocol?) {
        //
        switch intoSocket?.keypath as? String {
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
            assertionFailure("undefiend field \(String(describing: intoSocket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {}
}
