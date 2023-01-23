//
//  VehicleTreeRuleBuilder.swift
//  WOTApi
//
//  Created by Paul on 18.01.23.
//

public class VehicleTreeRuleBuilder: FetchRequestPredicateComposerProtocol {
    //
    let modelClass: PrimaryKeypathProtocol.Type
    let vehicleId: JSONValueType

    init(modelClass: PrimaryKeypathProtocol.Type, vehicleId: JSONValueType) {
        self.modelClass = modelClass
        self.vehicleId = vehicleId
    }

    public func buildRequestPredicateComposition() throws -> FetchRequestPredicateCompositionProtocol {
        let contextPredicate = ContextPredicate()
        contextPredicate[.primary] = modelClass.primaryKey(forType: .internal, andObject: vehicleId)
        return FetchRequestPredicateComposition(objectIdentifier: nil, requestPredicate: contextPredicate)
    }
}
