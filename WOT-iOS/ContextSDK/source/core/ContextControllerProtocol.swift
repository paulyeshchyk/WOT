//
//  WOTViewControllerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

import UIKit

// MARK: - ContextProtocol

public protocol ContextProtocol: LogInspectorContainerProtocol,
    DataStoreContainerProtocol,
    HostConfigurationContainerProtocol,
    RequestManagerContainerProtocol,
    ResponseManagerContainerProtocol,
    RequestListenerContainerProtocol,
    DecoderManagerContainerProtocol,
    RequestRegistratorContainerProtocol,
    UoW_ManagerContainerProtocol {}

// MARK: - ContextControllerProtocol

public protocol ContextControllerProtocol {
    var appContext: ContextProtocol? { get set }
}

// MARK: - ObjCContextProtocol

@objc(ContextProtocol)
public protocol ObjCContextProtocol: ObjCDatastoreContainerProtocol {
//
}

// MARK: - ObjCDatastoreContainerProtocol

@objc(DatastoreContainerProtocol)
public protocol ObjCDatastoreContainerProtocol {
    var dataStore: ObjCDataStoreProtocol { get }
}

// MARK: - ObjCDataStoreProtocol

@objc(DatastoreProtocol)
public protocol ObjCDataStoreProtocol {
    typealias ObjCDatastoreManagedObjectCompletion = (AnyObject, Error?) -> Void
    typealias ObjCThrowableContextCompletion = (AnyObject, Error?) -> Void
    func workingContext() -> AnyObject
    func perform(block: @escaping ObjCObjectContextCompletion)
    func stash(managedObject: AnyObject, completion: @escaping ObjCDatastoreManagedObjectCompletion)
    func stash(managedObjectContext: AnyObject, completion: @escaping ObjCThrowableContextCompletion)
}

public typealias ObjCObjectContextCompletion = (AnyObject) -> Void
