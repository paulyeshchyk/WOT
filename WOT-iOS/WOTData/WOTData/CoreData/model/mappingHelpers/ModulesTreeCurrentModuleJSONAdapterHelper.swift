//
//  ModulesTreeCurrentModuleJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

// MARK: - Mapping
@objc
public class ModulesTreeCurrentModuleJSONAdapterHelper: NSObject, JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?

    private var moduleTree: ModulesTree
    init(moduleTree: ModulesTree) {
        self.moduleTree = moduleTree
    }

    public func onInstanceDidParse(fetchResult: FetchResult) {
        let context = fetchResult.context
        if let module = fetchResult.managedObject() as? Module {
            moduleTree.currentModule = module
            persistentStore?.stash(context: context, hint: nil) { error in
                if let error = error {
                    print(error.debugDescription)
                }
            }
        }
    }

    public func onJSONExtraction(json: JSON) -> JSON? { return nil }
}
