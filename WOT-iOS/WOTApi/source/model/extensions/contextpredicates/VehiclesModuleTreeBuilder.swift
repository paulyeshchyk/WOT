//
//  VehiclesModuleTreeBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

/** Creates predicate

 vehicle moduleTree: default_profile.vehicles.tank_id == 1073

 */
public class VehiclesModuleTreeBuilder: FetchRequestPredicateComposerProtocol {
    private let contextPredicate: ContextPredicateProtocol
    private let jsonRefs: [JSONRefProtocol]

    public init(contextPredicate: ContextPredicateProtocol, jsonRefs: [JSONRefProtocol]) {
        self.contextPredicate = contextPredicate
        self.jsonRefs = jsonRefs
    }

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: jsonRefs)
        lookupPredicate[.primary] = contextPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        return lookupPredicate
    }
}
