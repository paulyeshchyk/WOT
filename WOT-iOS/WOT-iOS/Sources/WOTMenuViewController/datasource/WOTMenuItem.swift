//
//  WOTMenuItem.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

// MARK: - WOTMenuItemProtocol

@objc
protocol WOTMenuItemProtocol {
    @objc var controllerClass: UIViewController.Type { get }
    @objc var controllerTitle: String { get }
    @objc var icon: UIImage { get }
    @objc var userDependence: Bool { get }
}

// MARK: - WOTMenuItem

class WOTMenuItem: NSObject, WOTMenuItemProtocol {

    let controllerClass: UIViewController.Type
    let controllerTitle: String
    let icon: UIImage
    let userDependence: Bool

    // MARK: Lifecycle

    init(controllerClass clazz: UIViewController.Type, controllerTitle title: String, icon image: UIImage, userDependence dependence: Bool) {
        controllerClass = clazz
        controllerTitle = title
        icon = image
        userDependence = dependence
    }
}
