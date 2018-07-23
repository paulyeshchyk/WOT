//
//  WOTTankTreeFetchController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
class WOTTankTreeFetchController: WOTDataTanksFetchController {

    override func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol] {

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        var result = [WOTNodeProtocol]()

        let filtered = self.fetchedObjects()?.filter { predicate.evaluate(with: $0) }

        filtered?.forEach { (fetchedObject) in
            if let fetchObj = fetchedObject as? NSFetchRequestResult {
                if let node = self.nodeCreator?.createNode(fetchedObject: fetchObj, byPredicate: predicate) {
                    result.append(node)
                }
            }
        }
        return result
    }
}
