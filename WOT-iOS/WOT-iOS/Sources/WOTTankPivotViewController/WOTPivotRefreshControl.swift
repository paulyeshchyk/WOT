//
//  WOTPivotRefreshControl.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc class WOTPivotRefreshControl: UIRefreshControl {

    var contentOffset: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }

    // MARK: Lifecycle

    convenience init(target: Any, action: Selector) {
        self.init()
        let color = UIColor.red
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        addTarget(target, action: action, for: UIControl.Event.valueChanged)
        tintColor = color
        attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
    }

    // MARK: Internal

    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { (view) in
            let frame = view.frame.offsetBy(dx: -contentOffset.x, dy: 0)
            view.bounds = frame
        }
    }
}
