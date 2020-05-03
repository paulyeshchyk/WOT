//
//  CGRect_Center.swift
//  WOTPivot
//
//  Created on 2/14/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

extension CGRect {
    public func center() -> CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

    public func centerHorizontalBottomVertical() -> CGPoint {
        return CGPoint(x: self.midX, y: self.origin.y + self.size.height)
    }

    public func centerHorizontalTopVertical() -> CGPoint {
        return CGPoint(x: self.midX, y: self.origin.y)
    }
}
