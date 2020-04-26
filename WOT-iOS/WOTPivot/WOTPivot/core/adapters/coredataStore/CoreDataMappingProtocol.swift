//
//  CoreDataMappingProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public enum SubordinateRequestType: Int {
    case local = 0
    case remote = 1
}

@objc
public protocol CoreDataMappingProtocol {
    @available(*, deprecated)
    var mapper: WOTMappingCoordinatorProtocol? { get }

    /**
     Asks NSManagedObjectContext to find/create object by predicate
     - Parameter clazz: Type of requested object
     - Parameter pkCase: Set of predicates available for this request
     - Parameter callback: -
     */
    func requestSubordinate1(for clazz: AnyClass, _ pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectCallback )

    /**
     Asks Subordinator to save context before running links mapping
        - Parameter pkCase: just informative

     */
    func stash(hint: String?)

    func mapping(object: NSManagedObject?, fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol)
    func mapping(object: NSManagedObject?, fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol)
}

extension CoreDataMappingProtocol {
    public func stash(hint: Describable?) {
        self.stash(hint: hint?.description)
    }
}

extension CoreDataMappingProtocol {
    public func stash() { self.stash(hint: nil) }
}
