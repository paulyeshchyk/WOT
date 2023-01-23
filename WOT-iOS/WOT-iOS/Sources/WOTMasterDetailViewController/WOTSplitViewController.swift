//
//  WOTSplitViewController.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - WOTSplitBehaviour

struct WOTSplitBehaviour: OptionSet {
    static let moduleTree = WOTSplitBehaviour(rawValue: 1)

    let rawValue: Int
}

// MARK: - WOTMasterControllerProtocol

@objc
protocol WOTMasterControllerProtocol: NSObjectProtocol {}

// MARK: - WOTDetailControllerProtocol

@objc
protocol WOTDetailControllerProtocol: NSObjectProtocol {
    func showDetail(detail: Any?)
}

// MARK: - WOTMasterDetailBehaviour

struct WOTMasterDetailBehaviour {

    init(master: AnyClass, detail: AnyClass, behaviour: WOTSplitBehaviour) {
        masterController = master
        detailController = detail
        behaviourType = behaviour
    }

    var masterController: AnyClass
    var detailController: AnyClass
    var behaviourType: WOTSplitBehaviour
}

extension WOTMasterDetailBehaviour {
    static let PivotModuletree = WOTMasterDetailBehaviour(master: WOTSplitViewController.self, detail: WOTTankModuleTreeViewController.self, behaviour: .moduleTree)
}

// MARK: - WOTSplitViewController

@objc
class WOTSplitViewController: UISplitViewController, WOTMasterControllerProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
        let left = WOTTankPivotViewController(nibName: "WOTTankPivotViewController", bundle: nil)
        let leftNC = UINavigationController(rootViewController: left)
        let right = WOTTankModuleTreeViewController(nibName: "WOTTankModuleTreeViewController", bundle: nil)
        let rightNC = UINavigationController(rootViewController: right)
        viewControllers = [leftNC, rightNC]
    }
}
