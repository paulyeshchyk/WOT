//
//  VehiclesModuleBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

public class VehiclesModuleBuilder: RequestPredicateComposerProtocol {
    private let requestPredicate: ContextPredicateProtocol
    private let module_id: Any?

    #warning("module_id to be changed to pin")
    public init(requestPredicate: ContextPredicateProtocol, module_id: Any?) {
        self.requestPredicate = requestPredicate
        self.module_id = module_id
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(managedRefs: requestPredicate.managedRefs)
        lookupPredicate[.primary] = ModulesTree.primaryKey(forType: .internal, andObject: module_id)
        lookupPredicate[.secondary] = requestPredicate[.primary]
        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
