//
//  ModulesTreeManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModulesTreeManagedObjectCreator: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    public func extractJSON(from: JSON) -> JSON? {
        return from
    }
}
