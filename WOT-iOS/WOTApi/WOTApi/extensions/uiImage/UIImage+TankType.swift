//
//  UIImage+TankType.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import UIKit
import WOTKit

extension UIImage {
    @objc
    public static func image(forTankType: String) -> UIImage? {
        return AssetCatalogExtractor.createLocalImage(forImageNamed: forTankType, bundle: Bundle(for: WOTDataStore.self))
    }
}
