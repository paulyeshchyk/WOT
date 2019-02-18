//
//  WOTTankModuleTreeNodeConnectorLayerProtocol.swift
//  WOTPivot
//
//  Created on 2/14/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

@objc
public protocol WOTTankModuleTreeNodeConnectorLayerProtocol: NSObjectProtocol {

}

@objc
public protocol WOTTankConfigurationFlowCellLayoutProtocol {
    func cellFrame(indexPath: IndexPath) -> CGRect
    func layoutAttribute(indexPath: IndexPath, rect: CGRect) -> UICollectionViewLayoutAttributes?
    func layoutAttributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
}


