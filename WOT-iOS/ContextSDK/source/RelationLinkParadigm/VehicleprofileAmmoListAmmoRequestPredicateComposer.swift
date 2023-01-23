//
//  VehicleprofileAmmoListAmmoRequestPredicateComposer.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
//

public class VehicleprofileAmmoListAmmoRequestPredicateComposer: RequestPredicateComposerProtocol {

    public init(drivenJoint: Joint, foreignSelectKey: String) {
        self.drivenJoint = drivenJoint
        self.foreignSelectKey = foreignSelectKey
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.contextPredicate?[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        lookupPredicate[.secondary] = drivenJoint.modelClass.primaryKey(forType: .internal, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

    private let drivenJoint: Joint
    private var foreignSelectKey: String
}
