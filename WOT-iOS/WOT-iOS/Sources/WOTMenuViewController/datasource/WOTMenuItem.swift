//
//  WOTMenuItem.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - WOTMenuItemProtocol

@objc
protocol WOTMenuItemProtocol: NSObjectProtocol {
    var controllerClass: AnyClass { get }
    var controllerTitle: String { get }
    var icon: UIImage { get }
    var userDependence: Bool { get }
    init(controllerClass clazz: AnyClass, controllerTitle title: String, icon image: UIImage, userDependence dependence: Bool)
}

// MARK: - WOTMenuItem

@objc
class WOTMenuItem: NSObject {

    init(controllerClass clazz: ContextControllerProtocol.Type, controllerTitle title: String, icon image: UIImage, userDependence dependence: Bool) {
        controllerClass = clazz
        controllerTitle = title
        icon = image
        userDependence = dependence
    }

    @objc private(set) var controllerClass: ContextControllerProtocol.Type
    @objc private(set) var controllerTitle: String
    @objc private(set) var icon: UIImage
    @objc private(set) var userDependence: Bool
}
