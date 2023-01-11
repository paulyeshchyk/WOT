//
//  VehicleprofileAmmoListAmmoRequestPredicateComposer.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
//

public class VehicleprofileAmmoListAmmoRequestPredicateComposer: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private var foreignSelectKey: String

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, foreignSelectKey: String) {
        self.pin = pin
        self.foreignSelectKey = foreignSelectKey
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
