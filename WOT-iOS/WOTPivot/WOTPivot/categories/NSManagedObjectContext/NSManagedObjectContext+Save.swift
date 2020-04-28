//
//  NSManagedObjectContext+Save.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/28/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    public func saveRecursively(_ block: @escaping ThrowableCompletion) {
//        let parentBlock: ThrowableCompletion = { error in
//            if self.parent == nil {
//                block(error)
//            }
//        }

        performAndWait {
            if hasChanges {
                do {
                    try self.save()
                    if let parent = self.parent {
                        parent.saveRecursively(block)
                    } else {
                        block(nil)
                    }
                } catch let error {
                    block(error)
                }
            } else {
                block(nil)
            }
        }
    }
}
