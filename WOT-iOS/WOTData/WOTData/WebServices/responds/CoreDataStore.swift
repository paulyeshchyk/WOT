//
//  CoreDataStore.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public struct CoreDataStore {
    let Clazz: PrimaryKeypathProtocol.Type
    let request: WOTRequestProtocol
    let binary: Data?
    let linkAdapter: JSONLinksAdapterProtocol
    let context: NSManagedObjectContext
    var onGetIdent: ((PrimaryKeypathProtocol.Type, JSON, AnyHashable) -> Any)?
    var onGetObjectJSON: ((JSON) -> JSON)?

    func perform() {
        if let error = binary?.parseAsJSON(onReceivedJSON(_:)) {
            print(error)
        }
    }

    private func onReceivedJSON(_ json: JSON?) {
        json?.keys.forEach { (key) in
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

            let primaryKey = Clazz.primaryKey(for: ident as AnyObject)
            perform(primaryKey: primaryKey, json: objectJson)
        }
    }

    private func perform(primaryKey: WOTPrimaryKey?, json: JSON) {
        context.perform {
            if let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: primaryKey?.predicate, context: self.context) {
                managedObject.mapping(fromJSON: json, externalPK: primaryKey, onSubordinateCreate: self.onSubordinate(_:_:), linksCallback: self.onLinks(_:))
                self.context.tryToSave()
            }
        }
    }

    private func onSubordinate(_ clazz: AnyClass, _ primaryKey: WOTPrimaryKey?) -> NSManagedObject? {
        let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: primaryKey?.predicate, context: self.context)
        return managedObject
    }

    private func onLinks(_ links: [WOTJSONLink]?) {
        linkAdapter.request(request, adoptJsonLinks: links)
    }
}
