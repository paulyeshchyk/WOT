//
//  ColoredViewLayoutAttributes.swift
//  WOT-iOS
//
//  Created on 7/31/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

enum WOTPivotSeparatorKind: String {

    case top = "WOTPivotSeparatorKind.top"
    case bottom = "WOTPivotSeparatorKind.bottom"
    case left = "WOTPivotSeparatorKind.left"
    case right = "WOTPivotSeparatorKind.right"
}

class WOTPivotSeparatorLayoutAttributes: UICollectionViewLayoutAttributes {

    private var separatorWidth: CGFloat {
        return 1.0
    }

    private var topSeparatorFrame: CGRect {

        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.minX,
                      y: customFrame.minY - self.separatorWidth,
                      width: customFrame.width,
                      height: self.separatorWidth)
    }

    private var leftSeparatorFrame: CGRect {

        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.minX,
                      y: customFrame.minY - self.separatorWidth,
                      width: self.separatorWidth,
                      height: customFrame.height + self.separatorWidth)
    }

    private var bottomSeparatorFrame: CGRect {

        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.minX ,
                      y: customFrame.maxY - self.separatorWidth,
                      width: customFrame.width,
                      height: self.separatorWidth)
    }

    private var rightSeparatorFrame: CGRect {

        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.maxX,
                      y: customFrame.minY - self.separatorWidth,
                      width: self.separatorWidth,
                      height: customFrame.height + self.separatorWidth )
    }

    private func invalidateFrame(kind: WOTPivotSeparatorKind) {

        switch kind {
        case .top:
            self.frame = self.topSeparatorFrame
        case .left:
            self.frame = self.leftSeparatorFrame
        case .bottom:
            self.frame = self.bottomSeparatorFrame
        case .right:
            self.frame = self.rightSeparatorFrame
        }
    }

    var color: UIColor = UIColor.clear
    var kind: WOTPivotSeparatorKind? {
        didSet {
            guard let kindValue = kind else {
                return
            }
            invalidateFrame(kind: kindValue)
        }

    }
    var customFrame: CGRect? {
        didSet {
            guard let kindValue = kind else {
                return
            }
            invalidateFrame(kind: kindValue)
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
