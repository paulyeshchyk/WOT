//
//  Module+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension Module {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(Module.module_id)
        case .internal: return #keyPath(Module.module_id)
        default: fatalError("unknown type should never be used")
        }
    }
}
