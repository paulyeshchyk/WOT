//
//  WOTTankModuleTreeNodeConnectorLayerProtocol.swift
//  WOTPivot
//
//  Created on 2/14/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

// MARK: - WOTTankModuleTreeNodeConnectorLayerProtocol

@objc
public protocol WOTTankModuleTreeNodeConnectorLayerProtocol: NSObjectProtocol {}

// MARK: - WOTTankConfigurationFlowCellLayoutProtocol

@objc
public protocol WOTTankConfigurationFlowCellLayoutProtocol {
    func cellFrame(indexPath: IndexPath) -> CGRect
    func layoutAttribute(indexPath: IndexPath, rect: CGRect) -> UICollectionViewLayoutAttributes?
    func layoutAttributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
}
