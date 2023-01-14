//
//  VehiclesModuleTreeBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

public class VehiclesModuleTreeBuilder: RequestPredicateComposerProtocol {
    private let requestPredicate: ContextPredicateProtocol
    private let pins: [AnyObject]

    public init(requestPredicate: ContextPredicateProtocol, pins: [AnyObject]) {
        self.requestPredicate = requestPredicate
        self.pins = pins
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(pins: pins)
        lookupPredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
