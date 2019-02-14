//
//  WOTCoredataProviderProtocol.swift
//  WOTPivot
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

@objc
public enum WOTExecuteConcurency: Int {
    case mainQueue
    case privateQueue
}

@objc
public protocol WOTCoredataProviderProtocol: NSObjectProtocol {
    @objc var mainManagedObjectContext: NSManagedObjectContext { get }
    @objc var workManagedObjectContext: NSManagedObjectContext { get }
    @objc var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }

    @objc func executeRequest(by predicate: NSPredicate , concurency: WOTExecuteConcurency)
}
