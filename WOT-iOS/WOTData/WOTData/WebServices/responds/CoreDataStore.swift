//
//  CoreDataStore.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CoreDataStore: CoreDataSubordinatorProtocol {
    let Clazz: PrimaryKeypathProtocol.Type
    let request: WOTRequestProtocol
    let binary: Data?
    let linkAdapter: JSONLinksAdapterProtocol
    let context: NSManagedObjectContext
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)?
    var onGetObjectJSON: ((JSON) -> JSON)?
    var onFinishJSONParse: ((Error?) -> Void)?

    public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, binary: Data?, linkAdapter: JSONLinksAdapterProtocol, context: NSManagedObjectContext) {
        self.Clazz = clazz
        self.request = request
        self.binary = binary
        self.linkAdapter = linkAdapter
        self.context = context
    }

    func perform() {
        if let error = binary?.parseAsJSON(onReceivedJSON(_:)) {
            onFinishJSONParse?(error)
        }
    }

    private func perform(pkCase: PKCase, json: JSON, completion: @escaping ()->Void ) {
        context.perform {
            guard let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: pkCase[.primary]?.predicate, context: self.context) else {
                fatalError("Managed object is not created")
            }
            managedObject.mapping(fromJSON: json, pkCase: pkCase, forRequest: self.request, subordinator: self, linker: self)
            self.context.tryToSave()
            completion()
        }
    }

    // MARK: - CoreDataSubordinatorProtocol
    public func requestNewSubordinate(_ clazz: AnyClass, _ pkCase: PKCase, callback: @escaping NSManagedObjectCallback) {
        guard let predicate = pkCase.predicate else {
            print("[COREDATA][SEARCH] no key defined for class: \(String(describing: clazz))")
            return
        }
        context.perform {
            let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: self.context)
            callback(managedObject)
        }
    }

    public func willRequestLinks() {
        #warning("not thread safe")
        context.tryToSave()
    }
}

extension CoreDataStore {
    func onSubordinate(_ clazz: AnyClass, _ pkCase: PKCase) -> NSManagedObject? {
        let primaryKey = pkCase[.primary]
        let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: primaryKey?.predicate, context: self.context)
        return managedObject
    }
}

extension CoreDataStore: CoreDataLinkerProtocol {
    public func onLinks(_ links: [WOTJSONLink]?) {
        linkAdapter.request(request, adoptJsonLinks: links)
    }
}

extension CoreDataStore {
    func onReceivedJSON(_ json: JSON?) {
        let keys = json?.keys
        var mutatingKeysCounter = keys?.count ?? 0
        keys?.forEach { (key) in
            guard let jsonByKey = json?[key] as? JSON else {
                fatalError("invalid json for key")
            }
            let objectJson: JSON
            if let jsonExtractor = onGetObjectJSON {
                objectJson = jsonExtractor(jsonByKey)
            } else {
                objectJson = jsonByKey
            }
            guard let ident = onGetIdent?(Clazz, objectJson, key) else {
                fatalError("onGetIdent not defined")
            }

            let pkCase = PKCase()
            pkCase[.primary] = Clazz.primaryKey(for: ident as AnyObject)
            print("[JSON][START][\(pkCase)]")
            perform(pkCase: pkCase, json: objectJson) {
                mutatingKeysCounter -= 1
                if mutatingKeysCounter <= 0 {
                    self.onFinishJSONParse?(nil)
                }
            }
        }
    }
}
