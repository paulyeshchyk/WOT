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

    func perform() {
        if let error = binary?.parseAsJSON(onReceivedJSON(_:)) {
            print(error)
        }
    }

    private func onReceivedJSON(_ json: JSON?) {
        json?.keys.forEach { (key) in
            let primaryKeyPath = Clazz.primaryKeyPath()
            guard let objectJson = json?[key] as? JSON, let ident = objectJson[primaryKeyPath] else { return }

            perform(ident: ident, json: objectJson)
        }
    }

    private func perform(ident: Any, json: JSON) {
        let primaryKey = Clazz.primaryKey(for: ident as AnyObject)

        context.perform {
            if let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: primaryKey?.predicate, context: self.context) {
                managedObject.mapping(fromJSON: json, parentPrimaryKey: primaryKey, onSubordinateCreate: self.onSubordinate(_:_:), linksCallback: self.onLinks(_:))
                self.context.tryToSave()
            }
        }
    }

    private func onSubordinate(_ clazz: AnyClass, _ primaryKey: WOTPrimaryKey?) -> NSManagedObject? {
        let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: primaryKey?.predicate, context: self.context)
        return managedObject
    }

    private func onLinks(_ links: [WOTJSONLink]?) {
        self.linkAdapter.request(self.request, adoptJsonLinks: links)
    }
}
