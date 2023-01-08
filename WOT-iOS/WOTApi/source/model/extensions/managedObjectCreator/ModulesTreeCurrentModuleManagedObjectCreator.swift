//
//  ModulesTreeCurrentModuleManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModulesTreeCurrentModuleManagedObjectCreator: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

    // MARK: Public

    public func extractJSON(from: JSON) -> JSON? {
        return from
    }
}
