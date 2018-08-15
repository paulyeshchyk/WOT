//
//  WOTTankPivotViewController+WOTDataModelListener.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/6/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: WOTDataModelListener {

    func modelDidLoad() {
        self.collectionView?.reloadData()
        self.refreshControl.endRefreshing()
    }

    func modelHasNewDataItem() {

    }

    func modelDidFailLoad(error: Error) {

        self.refreshControl.endRefreshing()
    }

    func metadataItems() -> [WOTNodeProtocol] {

        var result = [WOTPivotNodeProtocol]()

        let templates = WOTPivotTemplates()
//        let levelPrem = templates.vehiclePremium
        let levelNati = templates.vehicleNation
        let levelType = templates.vehicleType
        let levelTier = templates.vehicleTier

        let permutator = WOTPivotMetadataPermutator()

        let cols = permutator.permutate(templates: [levelTier, levelType], as: .row)
        let rows = permutator.permutate(templates: [levelNati], as: .column)
        let filt = self.pivotFilters()

        result.append(contentsOf: cols)
        result.append(contentsOf: rows)
        result.append(contentsOf: filt)
        return result
    }

    func pivotFilters () -> [WOTPivotNodeProtocol] {
        return [WOTPivotFilterNode(name: "Filter")]
    }
}
