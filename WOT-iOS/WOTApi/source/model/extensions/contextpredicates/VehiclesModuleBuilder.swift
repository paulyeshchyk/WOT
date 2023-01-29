//
//  VehiclesModuleBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

public class VehiclesModuleBuilder: FetchRequestPredicateComposerProtocol {
    private let requestPredicate: ContextPredicateProtocol
    private let module_id: Any?

    #warning("module_id to be changed to pin")
    public init(requestPredicate: ContextPredicateProtocol, module_id: Any?) {
        self.requestPredicate = requestPredicate
        self.module_id = module_id
    }

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: requestPredicate.jsonRefs)
        lookupPredicate[.primary] = ModulesTree.primaryKey(forType: .internal, andObject: module_id)
        lookupPredicate[.secondary] = requestPredicate[.primary]

        return lookupPredicate
    }
}
