//
//  ModulesTree+WOTTreeModulesTreeProtocol.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import WOTPivot
import WOTKit

extension ModulesTree: WOTTreeModulesTreeProtocol {
    public func moduleType() -> String? {
        return self.type
    }

    public func moduleLocalImageURL() -> URL? {
        guard let imageName = self.type else {
            return nil
        }

        return AssetCatalogExtractor.createLocalUrl(forImageNamed: imageName, bundle: Bundle(for: Self.self))
    }

    public func moduleName() -> String {
        return self.name ?? ""
    }

    public func moduleValue(forKey: String) -> Any? {
        return nil
    }

    public func moduleIdInt() -> Int {
        return self.module_id!.intValue
    }

    public func isCompatible(forTankId: NSNumber) -> Bool {
        guard let tanksSet = self.next_tanks as? Set<Vehicles> else { return false }
        let filtered = tanksSet.filter { $0.tank_id?.intValue == forTankId.intValue }
        return filtered.count > 0
    }

    public func next_nodesId() -> [Int]? {
        return self.next_modules?.compactMap {
            ($0 as? Module)?.module_id?.intValue
        }
    }
}
