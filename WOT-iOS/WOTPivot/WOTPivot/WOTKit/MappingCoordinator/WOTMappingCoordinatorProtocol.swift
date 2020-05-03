//
//  WOTMapperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum WOTMapperError: Error {
    case contextNotDefined
    case objectIDNotDefined
}

public typealias ThrowableCompletion = (Error?) -> Void

@objc
public protocol WOTMappingCoordinatorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get }

    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, pkCase: PKCase, callback: @escaping FetchResultCompletion)

    func fetchRemote(context: NSManagedObjectContext, byModelClass modelClass: AnyClass, pkCase: PKCase, keypathPrefix: String?, instanceHelper: JSONAdapterInstanceHelper?)

    func mapping(json jSON: JSON, context: NSManagedObjectContext, object: NSManagedObject?, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, completion: @escaping ThrowableCompletion) throws

    func mapping(array: [Any], context: NSManagedObjectContext, object: NSManagedObject?, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, completion: @escaping ThrowableCompletion) throws
}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocal(json: JSON, context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, callback: @escaping FetchResultCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult in

            let context = fetchResult.context
            let newObject = fetchResult.managedObject()
            try? self.mapping(json: json, context: context, object: newObject, pkCase: pkCase, instanceHelper: instanceHelper) { error in
                let fetchResult = FetchResult(context: context, objectID: newObject.objectID, predicate: pkCase.compoundPredicate(), fetchStatus: FetchStatus.none, error: nil)
                if let instanceHelper = instanceHelper {
                    instanceHelper.onInstanceDidParse(fetchResult: fetchResult)
                } else {
                    callback(fetchResult)
                }
            }
        }
    }

    public func fetchLocal(array: [Any], context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, callback: @escaping FetchResultCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult in

            let context = fetchResult.context
            let newObject = fetchResult.managedObject()
            try? self.mapping(array: array, context: context, object: newObject, pkCase: pkCase, instanceHelper: instanceHelper) { error in
                let fetchResult = FetchResult(context: context, objectID: newObject.objectID, predicate: pkCase.compoundPredicate(), fetchStatus: FetchStatus.none, error: nil)
                if let instanceHelper = instanceHelper {
                    instanceHelper.onInstanceDidParse(fetchResult: fetchResult)
                } else {
                    callback(fetchResult)
                }
            }
        }
    }
}
