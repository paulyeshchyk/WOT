//
//  WOTMappingCoordinatorProtocol.swift
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

    func decodingAndMapping(json jSON: JSON, fetchResult: FetchResult, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, completion: @escaping ThrowableCompletion) throws

    func decodingAndMapping(array: [Any], fetchResult: FetchResult, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, completion: @escaping ThrowableCompletion) throws
}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocal(json: JSON, context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, callback: @escaping FetchResultCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult in

            try? self.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, instanceHelper: instanceHelper) { error in
                let finalFetchResult: FetchResult = fetchResult.dublicate()
                finalFetchResult.predicate = pkCase.compoundPredicate()
                finalFetchResult.error = error
                if let instanceHelper = instanceHelper {
                    instanceHelper.onInstanceDidParse(fetchResult: finalFetchResult)
                } else {
                    callback(fetchResult)
                }
            }
        }
    }

    public func fetchLocal(array: [Any], context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, instanceHelper: JSONAdapterInstanceHelper?, callback: @escaping FetchResultCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult in

            try? self.decodingAndMapping(array: array, fetchResult: fetchResult, pkCase: pkCase, instanceHelper: instanceHelper) { error in
                let finalFetchResult = fetchResult.dublicate()
                finalFetchResult.predicate = pkCase.compoundPredicate()
                finalFetchResult.error = error
                if let instanceHelper = instanceHelper {
                    instanceHelper.onInstanceDidParse(fetchResult: finalFetchResult)
                } else {
                    callback(fetchResult)
                }
            }
        }
    }
}
