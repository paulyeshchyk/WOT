//
//  VehicleprofileAmmoListAmmoRequestPredicateComposer.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
//

public class VehicleprofileAmmoListAmmoRequestPredicateComposer: RequestPredicateComposerProtocol {
    private let drivenJoint: Joint
    private var foreignSelectKey: String

    public init(drivenJoint: Joint, foreignSelectKey: String) {
        self.drivenJoint = drivenJoint
        self.foreignSelectKey = foreignSelectKey
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.thePredicate?[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        lookupPredicate[.secondary] = drivenJoint.theClass.primaryKey(forType: .internal, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
