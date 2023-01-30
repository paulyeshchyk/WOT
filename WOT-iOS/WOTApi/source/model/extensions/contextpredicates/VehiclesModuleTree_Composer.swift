//
//  VehiclesModuleTree_Composer.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

/** Creates predicate

 vehicle moduleTree: default_profile.vehicles.tank_id == 1073

 */
public class VehiclesModuleTree_Composer: FetchRequestPredicateComposerProtocol {
    private let parentContextPredicate: ContextPredicateProtocol
    private let parentJSONRefs: [JSONRefProtocol]

    public init(parentContextPredicate: ContextPredicateProtocol, parentJSONRefs: [JSONRefProtocol]) {
        self.parentContextPredicate = parentContextPredicate
        self.parentJSONRefs = parentJSONRefs
    }

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: parentJSONRefs)
        lookupPredicate[.primary] = parentContextPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        return lookupPredicate
    }
}
