//
//  ModulesTree+WOTTreeModulesTreeProtocol.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import WOTPivot

extension ModulesTree: WOTTreeModulesTreeProtocol {

    public func moduleType() -> String? {
        return type
    }

    public func moduleLocalImageURL() -> URL? {
        guard let imageName = type else {
            return nil
        }

        return AssetCatalogExtractor.createLocalUrl(forImageNamed: imageName, bundle: Bundle(for: Self.self))
    }

    public func moduleName() -> String {
        return name ?? ""
    }

    public func moduleValue(forKey _: String) -> Any? {
        return nil
    }

    public func moduleIdInt() -> Int {
        return module_id!.intValue
    }

    public func isCompatible(forTankId: NSNumber) -> Bool {
        guard let tanksSet = next_tanks as? Set<Vehicles> else { return false }
        let filtered = tanksSet.filter { $0.tank_id?.intValue == forTankId.intValue }
        return !filtered.isEmpty
    }

    public func next_nodesId() -> [Int]? {
        return next_modules?.compactMap {
            ($0 as? Module)?.module_id?.intValue
        }
    }
}
