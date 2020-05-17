//
//  WOTFetcherProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc public protocol WOTFetcherProtocol {

    var logInspector: LogInspectorProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get set }

    var requestRegistrator: WOTRequestRegistratorProtocol? { get set }
    var requestManager: WOTRequestManagerProtocol? { get set }


    func fetchLocal(context: NSManagedObjectContext, byModelClass clazz: NSManagedObject.Type, requestPredicate: RequestPredicate, callback: @escaping FetchResultErrorCompletion)
    func fetchRemote(paradigm: RequestParadigmProtocol)
}
