//
//  VehiclesModuleTreeBuilder.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

public class VehiclesModuleTreeBuilder: RequestPredicateComposerProtocol {
    private let jsonMap: JSONMapProtocol
    private let jsonRefs: [JSONRefProtocol]

    public init(jsonMap: JSONMapProtocol, jsonRefs: [JSONRefProtocol]) {
        self.jsonMap = jsonMap
        self.jsonRefs = jsonRefs
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: jsonRefs)
        lookupPredicate[.primary] = jsonMap.contextPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
