//
//  WOTMenuDatasource.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import WOTApi
import WOTPivot

@objc
protocol WOTMenuDatasourceDelegate: NSObjectProtocol {
    func hasUpdatedData(_ datasource: WOTMenuDatasourceProtocol)
}

@objc
protocol WOTMenuDatasourceProtocol: NSObjectProtocol {
    var delegate: WOTMenuDatasourceDelegate? { get set }
    func object(at index: Int) -> WOTMenuItem?
    func objectsCount() -> Int
    func rebuild()
}

@objc
class WOTMenuDatasource: NSObject, WOTMenuDatasourceProtocol {
    // MARK: - Properties

    weak var delegate: WOTMenuDatasourceDelegate?

    var availableViewControllers: [WOTMenuItem] = []
    var visibleViewControllers: [WOTMenuItem]? {
        didSet {
            delegate?.hasUpdatedData(self)
        }
    }

    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?

    override init() {
        super.init()

        availableViewControllers.append(WOTMenuItem(controllerClass: WOTTankPivotViewController.self, controllerTitle: WOTApi.L10n.wotStringTankdeleyev, icon: UIImage(), userDependence: false))
        availableViewControllers.append(WOTMenuItem(controllerClass: WOTTankListViewController.self, controllerTitle: WOTApi.L10n.wotStringTankopedia, icon: UIImage(), userDependence: false))
        availableViewControllers.append(WOTMenuItem(controllerClass: WOTPlayersListViewController.self, controllerTitle: WOTApi.L10n.wotStringPlayers, icon: UIImage(), userDependence: false))
        availableViewControllers.append(WOTMenuItem(controllerClass: WOTProfileViewController.self, controllerTitle: WOTApi.L10n.wotStringProfile, icon: UIImage(), userDependence: false))
    }

    func object(at index: Int) -> WOTMenuItem? {
        return visibleViewControllers?[index]
    }

    func objectsCount() -> Int {
        return visibleViewControllers?.count ?? 0
    }

    func rebuild() {
        if WOTSessionManager.sessionHasBeenExpired() {
            let predicate = NSPredicate(format: "SELF.userDependence = NO")
            visibleViewControllers = availableViewControllers.filter { predicate.evaluate(with: $0) }
        } else {
            var visibleViewControllers = [WOTMenuItem]()
            visibleViewControllers.append(contentsOf: availableViewControllers)
            self.visibleViewControllers = visibleViewControllers
        }
    }
}

extension WOTMenuDatasource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        rebuild()
    }
}
