//
//  WOTTankModuleTreeNodeConnectorLayer.swift
//  WOT-iOS
//
//  Created on 7/30/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

@objc
public class WOTTankModuleTreeNodeConnectorLayer: NSObject, WOTTankModuleTreeNodeConnectorLayerProtocol {
    @objc
    public static func connectors(forModel: WOTTreeDataModelProtocol, byFrame: CGRect, flowLayout: WOTTankConfigurationFlowCellLayoutProtocol) -> UIImage? {
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
}

extension CGContext {
    public func drawNodeConnector(frame: CGRect, node: WOTNodeProtocol, model: WOTDataModelProtocol, layout: WOTTankConfigurationFlowCellLayoutProtocol) {
        let parentCenter = frame.center()
        node.children.forEach { (child) in
            if let childIndexPath = model.indexPath(forNode: child) {
                let childFrame = layout.cellFrame(indexPath: childIndexPath)
                let childCenter = childFrame.center()

                self.move(to: childCenter)
                self.addLine(to: parentCenter)
                self.strokePath()
            }
        }
    }
}
