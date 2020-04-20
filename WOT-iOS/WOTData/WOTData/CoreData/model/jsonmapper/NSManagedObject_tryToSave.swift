//
//  JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public extension NSManagedObjectContext {
    @discardableResult
    func tryToSave() -> Error? {
        guard self.hasChanges else { return nil }

        var result: Error?
        do {
            try save()
        } catch {
            result = error
            print("\(#file) \(#function) at \(error.localizedDescription)")
        }
        return result
    }
}
