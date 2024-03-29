//
//  WOTTankModuleTreeNodeConnectorLayer.swift
//  WOT-iOS
//
//  Created on 7/30/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - WOTTankModuleTreeNodeConnectorLayer

@objc
public class WOTTankModuleTreeNodeConnectorLayer: NSObject, WOTTankModuleTreeNodeConnectorLayerProtocol {
    @objc
    public static func connectors(forModel: TreeDataModelProtocol, byFrame: CGRect, flowLayout: WOTTankConfigurationFlowCellLayoutProtocol) -> UIImage? {
        UIGraphicsBeginImageContext(byFrame.size)
        guard let uiGraphicsContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        uiGraphicsContext.setLineWidth(1)
        uiGraphicsContext.setStrokeColor(UIColor.yellow.cgColor)

        for i in 0 ..< forModel.levels {
            for j in 0 ..< forModel.nodesCount(section: i) {
                let indexPath = IndexPath(row: j, section: i)
                let frame = flowLayout.cellFrame(indexPath: indexPath)
                if let node = forModel.node(atIndexPath: indexPath) {
                    uiGraphicsContext.drawNodeConnector(frame: frame, node: node, model: forModel, layout: flowLayout)
                }
            }
        }

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

public extension CGContext {
    func drawNodeConnector(frame: CGRect, node: NodeProtocol, model: NodeDataModelProtocol, layout: WOTTankConfigurationFlowCellLayoutProtocol) {
        let parentCenter = frame.centerHorizontalBottomVertical()
        node.children.forEach { (child) in
            if let childIndexPath = model.indexPath(forNode: child) {
                let childFrame = layout.cellFrame(indexPath: childIndexPath)
                let childCenter = childFrame.centerHorizontalTopVertical()

                self.move(to: childCenter)
                self.addLine(to: parentCenter)
                self.strokePath()
            }
        }
    }
}

public extension CGRect {
    func center() -> CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    func centerHorizontalBottomVertical() -> CGPoint {
        return CGPoint(x: midX, y: origin.y + size.height - 46)
    }

    func centerHorizontalTopVertical() -> CGPoint {
        return CGPoint(x: midX, y: origin.y + 3)
    }
}
