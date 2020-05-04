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

    func fetchRemote(context: NSManagedObjectContext, byModelClass modelClass: AnyClass, pkCase: PKCase, keypathPrefix: String?, linker: JSONAdapterLinkerProtocol?)

    func decodingAndMapping(json jSON: JSON, fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping ThrowableCompletion) throws

    func decodingAndMapping(array: [Any], fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping ThrowableCompletion) throws
}

public enum WOTMappingCoordinatorError: Error {
    case linkerNotStarted
}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocal(json: JSON, context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult in

            try? self.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, linker: linker) { error in
                let finalFetchResult: FetchResult = fetchResult.dublicate()
                finalFetchResult.predicate = pkCase.compoundPredicate()
                finalFetchResult.error = error
                if let linker = linker {
                    linker.process(fetchResult: finalFetchResult, completion: callback)
                } else {
                    callback(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                }
            }
        }
    }

    public func fetchLocal(array: [Any], context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult in

            try? self.decodingAndMapping(array: array, fetchResult: fetchResult, pkCase: pkCase, linker: linker) { error in
                let finalFetchResult = fetchResult.dublicate()
                finalFetchResult.predicate = pkCase.compoundPredicate()
                finalFetchResult.error = error
                if let linker = linker {
                    linker.process(fetchResult: finalFetchResult, completion: callback)
                } else {
                    callback(fetchResult, WOTMappingCoordinatorError.linkerNotStarted)
                }
            }
        }
    }
}
