//
//  Link.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

public struct Joint {
    let theClass: PrimaryKeypathProtocol.Type
    let theID: JSONValueType?
    let thePredicate: ContextPredicate?
    public init(theClass: PrimaryKeypathProtocol.Type, theID: JSONValueType?, thePredicate: ContextPredicate?) {
        self.theClass = theClass
        self.theID = theID
        self.thePredicate = thePredicate
    }
}
