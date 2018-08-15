//
//  WOTSplitViewController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/14/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

struct WOTSplitBehaviour: OptionSet {
    let rawValue: Int
    static let moduleTree = WOTSplitBehaviour(rawValue: 1)
}

@objc
protocol WOTMasterControllerProtocol: NSObjectProtocol {

}

@objc
protocol WOTDetailControllerProtocol: NSObjectProtocol {
    func showDetail(detail: Any?)
}

struct WOTMasterDetailBehaviour {
    var masterController: AnyClass
    var detailController: AnyClass
    var behaviourType: WOTSplitBehaviour
    init(master: AnyClass, detail: AnyClass, behaviour: WOTSplitBehaviour) {
        masterController = master
        detailController = detail
        behaviourType = behaviour
    }
}


extension WOTMasterDetailBehaviour {
    static let PivotModuletree = WOTMasterDetailBehaviour(master: WOTSplitViewController.self, detail: WOTTankModuleTreeViewController.self, behaviour: .moduleTree)
}


@objc
class WOTSplitViewController: UISplitViewController, WOTMasterControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible
        let left = WOTTankPivotViewController(nibName: "WOTTankPivotViewController", bundle: nil)
        let leftNC = UINavigationController(rootViewController: left)
        let right = WOTTankModuleTreeViewController(nibName: "WOTTankModuleTreeViewController", bundle: nil)
        let rightNC = UINavigationController(rootViewController: right)
        self.viewControllers = [leftNC, rightNC]

    }
}
