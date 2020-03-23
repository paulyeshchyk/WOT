//
//  WOTMenuItem.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
protocol WOTMenuItemProtocol: NSObjectProtocol {
    var controllerClass: AnyClass { get }
    var controllerTitle: String { get }
    var icon: UIImage { get }
    var userDependence: Bool { get }
    init(controllerClass clazz: AnyClass, controllerTitle title: String, icon image: UIImage, userDependence dependence: Bool)
}

@objc
class WOTMenuItem: NSObject {
    @objc private(set)var controllerClass: AnyClass
    @objc private(set)var controllerTitle: String
    @objc private(set)var icon: UIImage
    @objc private(set)var userDependence: Bool

    init(controllerClass clazz: AnyClass, controllerTitle title: String, icon image: UIImage, userDependence dependence: Bool) {
        controllerClass = clazz
        controllerTitle = title
        icon = image
        userDependence = dependence
    }
}
