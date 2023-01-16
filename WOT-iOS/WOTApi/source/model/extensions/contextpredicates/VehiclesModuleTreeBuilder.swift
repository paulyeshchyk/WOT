//
//  VehiclesModuleTreeBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

public class VehiclesModuleTreeBuilder: RequestPredicateComposerProtocol {
    private let requestPredicate: ContextPredicateProtocol
    private let managedRefs: [ManagedRefProtocol]
    private let jsonRefs: [JSONRefProtocol]

    public init(requestPredicate: ContextPredicateProtocol, managedRefs: [ManagedRefProtocol], jsonRefs: [JSONRefProtocol]) {
        self.requestPredicate = requestPredicate
        self.managedRefs = managedRefs
        self.jsonRefs = jsonRefs
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(managedRefs: managedRefs, jsonRefs: jsonRefs)
        lookupPredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
