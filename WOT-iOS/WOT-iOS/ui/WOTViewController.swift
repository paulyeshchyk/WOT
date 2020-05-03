//
//  WOTViewController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import UIKit

@objc
public protocol WOTViewControllerProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
}

@objc
open class WOTViewController: UIViewController, WOTViewControllerProtocol {
    public var appManager: WOTAppManagerProtocol?
}
