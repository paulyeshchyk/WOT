//
//  CGRect_Center.swift
//  WOTPivot
//
//  Created on 2/14/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

public extension CGRect {
    func center() -> CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    func centerHorizontalBottomVertical() -> CGPoint {
        return CGPoint(x: midX, y: origin.y + size.height)
    }

    func centerHorizontalTopVertical() -> CGPoint {
        return CGPoint(x: midX, y: origin.y)
    }
}
