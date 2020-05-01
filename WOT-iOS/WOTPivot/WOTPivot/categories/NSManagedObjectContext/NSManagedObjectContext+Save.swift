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
        let privateCompletion: ThrowableCompletion = { error in
            self.perform {
                block(error)
            }
        }
        guard hasChanges else {
            privateCompletion(nil)
            return
        }

        performAndWait {
            do {
                try self.save()
                if let parent = self.parent {
                    parent.saveRecursively(privateCompletion)
                } else {
                    privateCompletion(nil)
                }
            } catch let error {
                privateCompletion(error)
            }
        }
    }
}
