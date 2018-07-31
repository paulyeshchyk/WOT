//
//  ColoredViewLayoutAttributes.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/31/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

enum WOTPivotSeparatorKind: String {

    case top = "WOTPivotSeparatorKind.top"
    case bottom = "WOTPivotSeparatorKind.bottom"
    case left = "WOTPivotSeparatorKind.left"
    case right = "WOTPivotSeparatorKind.right"
}

class WOTPivotSeparatorLayoutAttributes: UICollectionViewLayoutAttributes {

    private func invalidateFrame() {
        let separatorWidth: CGFloat = 1
        guard let customFrame = self.customFrame else {
            return
        }
        guard let kind = self.kind else {
            return
        }
        switch kind {
        case .top:
            self.frame = CGRect(x: customFrame.minX,
                                y: customFrame.minY - separatorWidth,
                                width: customFrame.width,
                                height: separatorWidth)
        case .left:
            self.frame = CGRect(x: customFrame.minX,
                                y: customFrame.minY - separatorWidth,
                                width: separatorWidth,
                                height: customFrame.height + separatorWidth)
        case .bottom:
            self.frame = CGRect(x: customFrame.minX ,
                                y: customFrame.maxY - separatorWidth,
                                width: customFrame.width,
                                height: separatorWidth)
        case .right:
            self.frame = CGRect(x: customFrame.maxX,
                                y: customFrame.minY - separatorWidth,
                                width: separatorWidth,
                                height: customFrame.height + separatorWidth )
        }
    }

    var color: UIColor = UIColor.clear
    var kind: WOTPivotSeparatorKind? {
        didSet {
            invalidateFrame()
        }

    }
    var customFrame: CGRect? {
        didSet {
            invalidateFrame()
        }
    }
}

class WOTPivotSeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let coloredLayoutAttributes = layoutAttributes as? WOTPivotSeparatorLayoutAttributes else {
            return
        }
        backgroundColor = coloredLayoutAttributes.color
    }
}
