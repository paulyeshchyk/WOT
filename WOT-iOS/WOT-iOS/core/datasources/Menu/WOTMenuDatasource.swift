//
//  WOTMenuDatasource.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData
import WOTData
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
    var visibleViewControllers: [WOTMenuItem]? = nil {
        didSet {
            self.delegate?.hasUpdatedData(self)
        }
    }

    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?

    override init() {
        super.init()

        VIPERModule.Pivot.wireFrame?.build(configureCallback: { (_) in

        })

        self.availableViewControllers.append(WOTMenuItem(controllerClass: WOTTankPivotViewController.self, controllerTitle: L10n.wotStringTankdeleyev, icon: UIImage(), userDependence: false))
        self.availableViewControllers.append(WOTMenuItem(controllerClass: WOTTankListViewController.self, controllerTitle: L10n.wotStringTankopedia, icon: UIImage(), userDependence: false))
        self.availableViewControllers.append(WOTMenuItem(controllerClass: WOTPlayersListViewController.self, controllerTitle: L10n.wotStringPlayers, icon: UIImage(), userDependence: false))
        self.availableViewControllers.append(WOTMenuItem(controllerClass: WOTProfileViewController.self, controllerTitle: L10n.wotStringProfile, icon: UIImage(), userDependence: false))
    }

    func object(at index: Int) -> WOTMenuItem? {
        return self.visibleViewControllers?[index]
    }

    func objectsCount() -> Int {
        return self.visibleViewControllers?.count ?? 0
    }

    func rebuild() {
        if WOTSessionManager.sessionHasBeenExpired() {
            let predicate = NSPredicate(format: "SELF.userDependence = NO")
            self.visibleViewControllers = self.availableViewControllers.filter { predicate.evaluate(with: $0) }
        } else {
            var visibleViewControllers = [WOTMenuItem]()
            visibleViewControllers.append(contentsOf: self.availableViewControllers)
            self.visibleViewControllers = visibleViewControllers
        }
    }
}

extension WOTMenuDatasource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.rebuild()
    }
}
