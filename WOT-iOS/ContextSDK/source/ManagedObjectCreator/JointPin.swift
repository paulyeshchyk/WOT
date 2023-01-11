//
//  ManagedObjectLinkerPin.swift
//  ContextSDK
//
//  Created by Paul on 11.01.23.
//

public struct JointPin: JointPinProtocol {

    public let modelClass: PrimaryKeypathProtocol.Type
    public let identifier: JSONValueType?
    public let contextPredicate: ContextPredicateProtocol?

    // MARK: Lifecycle

    public init(modelClass: PrimaryKeypathProtocol.Type, identifier: JSONValueType?, contextPredicate: ContextPredicateProtocol?) {
        self.modelClass = modelClass
        self.identifier = identifier
        self.contextPredicate = contextPredicate
    }

}
