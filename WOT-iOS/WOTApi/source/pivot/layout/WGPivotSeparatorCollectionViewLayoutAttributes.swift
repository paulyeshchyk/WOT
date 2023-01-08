//
//  WGPivotSeparatorCollectionViewLayoutAttributes.swift
//  WOT-iOS
//
//  Created on 7/31/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - WOTPivotSeparatorKind

enum WOTPivotSeparatorKind: String {
    case top
    case bottom
    case left
    case right
}

// MARK: - WGPivotSeparatorCollectionViewLayoutAttributes

class WGPivotSeparatorCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

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

    private var separatorWidth: CGFloat {
        return 1.0
    }

    private var topSeparatorFrame: CGRect {
        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.minX,
                      y: customFrame.minY - separatorWidth,
                      width: customFrame.width,
                      height: separatorWidth)
    }

    private var leftSeparatorFrame: CGRect {
        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.minX,
                      y: customFrame.minY - separatorWidth,
                      width: separatorWidth,
                      height: customFrame.height + separatorWidth)
    }

    private var bottomSeparatorFrame: CGRect {
        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.minX,
                      y: customFrame.maxY - separatorWidth,
                      width: customFrame.width,
                      height: separatorWidth)
    }

    private var rightSeparatorFrame: CGRect {
        let customFrame = self.customFrame ?? CGRect.zero
        return CGRect(x: customFrame.maxX,
                      y: customFrame.minY - separatorWidth,
                      width: separatorWidth,
                      height: customFrame.height + separatorWidth)
    }

    // MARK: Private

    private func invalidateFrame(kind: WOTPivotSeparatorKind) {
        switch kind {
        case .top:
            frame = topSeparatorFrame
        case .left:
            frame = leftSeparatorFrame
        case .bottom:
            frame = bottomSeparatorFrame
        case .right:
            frame = rightSeparatorFrame
        }
    }
}

// MARK: - WGPivotSeparatorCollectionReusableView

class WGPivotSeparatorCollectionReusableView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let coloredLayoutAttributes = layoutAttributes as? WGPivotSeparatorCollectionViewLayoutAttributes else {
            return
        }
        backgroundColor = coloredLayoutAttributes.color
    }
}
