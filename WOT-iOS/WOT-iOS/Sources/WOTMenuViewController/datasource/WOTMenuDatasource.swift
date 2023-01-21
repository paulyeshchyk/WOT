//
//  WOTMenuDatasource.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import WOTApi
import WOTPivot

// MARK: - WOTMenuDatasourceDelegate

@objc
protocol WOTMenuDatasourceDelegate: AnyObject {
    func hasUpdatedData(_ datasource: WOTMenuDatasourceProtocol)
}

// MARK: - WOTMenuDatasourceProtocol

@objc
protocol WOTMenuDatasourceProtocol {
    var delegate: WOTMenuDatasourceDelegate? { get set }
    init()
    func object(at index: Int) -> WOTMenuItem?
    func objectsCount() -> Int
    func rebuild()
}

// MARK: - WOTMenuDatasource

class WOTMenuDatasource: NSObject, WOTMenuDatasourceProtocol {

    // MARK: - Properties

    weak var delegate: WOTMenuDatasourceDelegate?

    private var availableViewControllers: [WOTMenuItem] = []
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?

    var visibleViewControllers: [WOTMenuItem]? {
        didSet {
            delegate?.hasUpdatedData(self)
        }
    }

    // MARK: Lifecycle

    override required init() {
        super.init()

        availableViewControllers.append(WOTMenuItem(controllerClass: WOTTankPivotViewController.self, controllerTitle: WOTApi.L10n.wotStringTankdeleyev, icon: UIImage(), userDependence: false))
        availableViewControllers.append(WOTMenuItem(controllerClass: WOTTankListViewController.self, controllerTitle: WOTApi.L10n.wotStringTankopedia, icon: UIImage(), userDependence: false))
        availableViewControllers.append(WOTMenuItem(controllerClass: WOTPlayersListViewController.self, controllerTitle: WOTApi.L10n.wotStringPlayers, icon: UIImage(), userDependence: false))
        availableViewControllers.append(WOTMenuItem(controllerClass: WOTProfileViewController.self, controllerTitle: WOTApi.L10n.wotStringProfile, icon: UIImage(), userDependence: false))
    }

    // MARK: Internal

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

// MARK: - WOTMenuDatasource + NSFetchedResultsControllerDelegate

extension WOTMenuDatasource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        rebuild()
    }
}
