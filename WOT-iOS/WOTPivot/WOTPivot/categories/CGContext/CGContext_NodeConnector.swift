//
//  CGContext_NodeConnector.swift
//  WOTPivot
//
//  Created on 2/14/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

extension CGContext {
    public func drawNodeConnector(frame: CGRect, node: WOTNodeProtocol, model: WOTDataModelProtocol, layout: WOTTankConfigurationFlowCellLayoutProtocol ) {
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

