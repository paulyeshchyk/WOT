//
//  VehiclesModuleTreeBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

public class VehiclesModuleTreeBuilder: RequestPredicateComposerProtocol {
    private let requestPredicate: ContextPredicateProtocol
    private let parentObjectIDList: [AnyObject]
    public init(requestPredicate: ContextPredicateProtocol, parentObjectIDList: [AnyObject]) {
        self.requestPredicate = requestPredicate
        self.parentObjectIDList = parentObjectIDList
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
