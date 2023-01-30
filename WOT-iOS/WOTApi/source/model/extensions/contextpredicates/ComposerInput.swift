//
//  ComposerInput.swift
//  WOTApi
//
//  Created by Paul on 30.01.23.
//

// MARK: - ComposerInputProtocol

public protocol ComposerInputProtocol {
    var parentKey: String? { get set }
    var parentPin: JointPinProtocol? { get set }
    var pin: JointPinProtocol? { get set }
    var parentContextPredicate: ContextPredicateProtocol? { get set }
    var parentJSONRefs: [JSONRefProtocol]? { get set }
    var contextPredicate: ContextPredicateProtocol? { get set }
}

// MARK: - ComposerInput

public class ComposerInput: ComposerInputProtocol {
    public var parentKey: String?
    public var parentPin: JointPinProtocol?
    public var pin: JointPinProtocol?
    public var parentContextPredicate: ContextPredicateProtocol?
    public var parentJSONRefs: [JSONRefProtocol]?
    public var contextPredicate: ContextPredicateProtocol?
}

// MARK: - ComposerProtocol

public protocol ComposerProtocol {
    func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol
}
