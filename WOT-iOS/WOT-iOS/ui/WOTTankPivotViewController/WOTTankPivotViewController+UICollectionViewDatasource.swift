//
//  WOTTankPivotViewController+UICollectionViewDatasource.swift
//  WOT-iOS
//
//  Created on 8/10/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let node = self.model.item(atIndexPath: indexPath as NSIndexPath) else {
            return UICollectionViewCell()
        }
        return self.cell(forNode: node, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.itemsCount(section: section)
    }
}

extension WOTTankPivotViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pivotNode = self.model.item(atIndexPath: indexPath as NSIndexPath)  else {
            return
        }

        guard self.hasOpenedPopover == false else {
            self.closePopover()
            return
        }

        switch pivotNode.cellType {
        case .data: openTankDetail(data: pivotNode.data1)
        case .dataGroup: openPopover()
        default: break
        }

    }

    private func openTankDetail(data: NSManagedObject?) {
        guard let tank = data as? Tanks else {
            return
        }
        let config = WOTTankModuleTreeViewController(nibName: String(describing: WOTTankModuleTreeViewController.self ), bundle: nil)
        config.tank_Id = tank.tank_id
        config.cancelBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        config.doneBlock = { (conf) in
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(config, animated: true)
    }
}

extension WOTTankPivotViewController {

    static var openedPopoverKey: UInt8 = 0
    var hasOpenedPopover: Bool {
        get {
            guard let result = objc_getAssociatedObject(self, &WOTTankPivotViewController.openedPopoverKey) as? Bool else {
                return false
            }
            return result
        }
        set {
            objc_setAssociatedObject(self, &WOTTankPivotViewController.openedPopoverKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    func closePopover () {
        self.hasOpenedPopover = false

    }

    func openPopover () {

        //        let viewController = UIViewController()
        //        viewController.modalPresentationStyle = UIModalPresentationStyle.popover
        //        viewController.
        //        guard let popover = viewController.popoverPresentationController else {
        //            return
        //        }
        //        self.present(viewController, animated: true) {
        //
        //        }

        self.hasOpenedPopover = true
    }
}
