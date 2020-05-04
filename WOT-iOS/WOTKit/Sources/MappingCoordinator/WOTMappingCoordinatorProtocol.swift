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

public enum WOTMappingCoordinatorError: Error {
    case requestsNotParsed
    case linkerNotStarted
    case noKeysDefinedForClass(String)
}

@objc
public protocol WOTMappingCoordinatorProtocol: LogInspectorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get }

    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, pkCase: PKCase, callback: @escaping FetchResultErrorCompletion)

    func fetchRemote(context: NSManagedObjectContext, byModelClass modelClass: AnyClass, pkCase: PKCase, keypathPrefix: String?, linker: JSONAdapterLinkerProtocol?)

    func decodingAndMapping(json jSON: JSON, fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)

    func decodingAndMapping(array: [Any], fetchResult: FetchResult, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, completion: @escaping FetchResultErrorCompletion)
}

extension WOTMappingCoordinatorProtocol {
    //
    public func fetchLocal(json: JSON, context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            try? self.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, linker: linker) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let linker = linker {
                        linker.process(fetchResult: fetchResult, completion: callback)
                    } else {
                        callback(fetchResult, nil)//WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }

    public func fetchLocal(array: [Any], context: NSManagedObjectContext, forClass Clazz: NSManagedObject.Type, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion) {
        //
        fetchLocal(context: context, byModelClass: Clazz, pkCase: pkCase) { fetchResult, error in

            if let error = error {
                callback(fetchResult, error)
                return
            }

            self.decodingAndMapping(array: array, fetchResult: fetchResult, pkCase: pkCase, linker: linker) { fetchResult, error in
                if let error = error {
                    callback(fetchResult, error)
                } else {
                    if let linker = linker {
                        linker.process(fetchResult: fetchResult, completion: callback)
                    } else {
                        callback(fetchResult, nil) //WOTMappingCoordinatorError.linkerNotStarted
                    }
                }
            }
        }
    }
}
