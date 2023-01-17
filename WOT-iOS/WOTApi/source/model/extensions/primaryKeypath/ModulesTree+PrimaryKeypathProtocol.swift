//
//  ModulesTree+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension ModulesTree {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(ModulesTree.module_id)
        case .internal: return #keyPath(ModulesTree.module_id)
        default: fatalError("unknown type should never be used")
        }
    }
}
