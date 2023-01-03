//
//  Link.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

public struct Joint {

    public init(modelClass: PrimaryKeypathProtocol.Type, theID: JSONValueType?, thePredicate: ContextPredicateProtocol?) {
        self.modelClass = modelClass
        self.theID = theID
        self.thePredicate = thePredicate
    }

    let modelClass: PrimaryKeypathProtocol.Type
    let theID: JSONValueType?
    let thePredicate: ContextPredicateProtocol?
}
