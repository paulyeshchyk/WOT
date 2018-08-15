//
//  WOTTankModuleTreeNodeConnectorLayer.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/30/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

@objc
protocol WOTTankModuleTreeNodeConnectorLayerProtocol: NSObjectProtocol {

}

extension CGContext {

    func drawNodeConnector(frame: CGRect, node: WOTNodeProtocol, model: WOTDataModelProtocol, layout: WOTTankConfigurationFlowCellLayoutProtocol ) {
        let parentCenter = WOTTankModuleTreeNodeConnectorLayer.center(rect: frame)
        node.children.forEach { (child) in
            if let childIndexPath = model.indexPath(forNode: child) {
                let childFrame = layout.cellFrame(indexPath: childIndexPath)
                let childCenter = WOTTankModuleTreeNodeConnectorLayer.center(rect: childFrame)

                self.move(to: childCenter)
                self.addLine(to: parentCenter)
                self.strokePath()
            }
        }
    }
}

@objc
class WOTTankModuleTreeNodeConnectorLayer: NSObject, WOTTankModuleTreeNodeConnectorLayerProtocol {

    @objc
    static func connectors(forModel: WOTDataModelProtocol, byFrame: CGRect, flowLayout: WOTTankConfigurationFlowCellLayoutProtocol) -> UIImage? {
        UIGraphicsBeginImageContext(byFrame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.yellow.cgColor)

        for i in 0 ..< forModel.levels {
            for j in 0 ..< forModel.nodesCount(section: i) {
                let indexPath = IndexPath(row: j, section: i)
                let frame = flowLayout.cellFrame(indexPath: indexPath)
                if let node = forModel.node(atIndexPath: indexPath as NSIndexPath) {
                    context.drawNodeConnector(frame: frame, node: node, model: forModel, layout: flowLayout)
                }
            }
        }

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    static func center(rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }

    static func centerHorizontalBottomVertical(rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.origin.y + rect.size.height)
    }

    static func centerHorizontalTopVertical(rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.origin.y)
    }

}
