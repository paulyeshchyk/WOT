//
//  ModulesTreeNextModulesJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public class ModulesTreeNextModulesJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?

    private var modulesTree: ModulesTree
    init(modulesTree: ModulesTree) {
        self.modulesTree = modulesTree
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let nextModule = fetchResult.managedObject() as? Module {
            modulesTree.addToNext_modules(nextModule)
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    public func onJSONExtraction(json: JSON) -> JSON? { return nil }
}
