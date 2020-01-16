//
//  NSManagedObject+SaveContext.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public extension NSManagedObject {
    
    @discardableResult
    func tryToSave() -> Error? {
        
        return self.managedObjectContext?.tryToSave()
    }
}

public extension NSManagedObjectContext {
    
    @discardableResult
    func tryToSave() -> Error? {
        
        guard !self.hasChanges else { return nil }

        var result: Error? = nil
        do {
            try save()
        } catch {
            result = error
            print("\(#file) \(#function) at \(error.localizedDescription)")
        }
        return result
    }
}
