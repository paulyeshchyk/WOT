//
//  WOTTankPivotViewController+WOTDataModelListener.swift
//  WOT-iOS
//
//  Created on 8/6/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import WOTPivot

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
        let levelPrem = templates.vehiclePremium
        let levelNati = templates.vehicleNation
        let levelType = templates.vehicleType
        let levelTier = templates.vehicleTier

        let permutator = WOTPivotMetadataPermutator()

        let cols = permutator.permutate(templates: [levelNati, levelType], as: .column)
        let rows = permutator.permutate(templates: [levelTier], as: .row)
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
