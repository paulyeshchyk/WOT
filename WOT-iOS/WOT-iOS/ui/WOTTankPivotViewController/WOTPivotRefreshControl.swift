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

    convenience init(target: Any, action: Selector) {
        self.init()
        let color = UIColor.red
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        self.addTarget(target, action: action, for: UIControl.Event.valueChanged)
        self.tintColor = color
        self.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { (view) in
            let frame = view.frame.offsetBy(dx: -contentOffset.x, dy: 0)
            view.bounds = frame
        }
    }
}
