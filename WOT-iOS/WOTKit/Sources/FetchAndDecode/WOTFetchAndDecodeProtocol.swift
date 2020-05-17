//
//  WOTFetchAndDecodeProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc public protocol WOTFetchAndDecodeProtocol {
    var logInspector: LogInspectorProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get set }
    var decoderAndMapper: WOTDecodeAndMappingProtocol? { get set }
    var requestRegistrator: WOTRequestRegistratorProtocol? { get set }
    var requestManager: WOTRequestManagerProtocol? { get set }

    func fetchLocalAndDecode(json: JSON, context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion)
    func fetchLocalAndDecode(array: [Any], context: NSManagedObjectContext, forClass Clazz: PrimaryKeypathProtocol.Type, requestPredicate: RequestPredicate, mapper: JSONAdapterLinkerProtocol?, callback: @escaping FetchResultErrorCompletion)

    func fetchRemote(paradigm: RequestParadigmProtocol)
}
