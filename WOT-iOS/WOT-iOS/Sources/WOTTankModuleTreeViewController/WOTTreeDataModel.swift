//
//  WOTTreeDataModel.swift
//  WOT-iOS
//
//  Created by Paul on 2.02.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

@objc
class WOTTreeDataModel: TreeDataModel {
    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestRegistratorContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    @objc func fetchVehicleData(vehicleId: Int) {
        WOTWEBRequestFactory.fetchVehicleTreeData(vehicleId: vehicleId, appContext: appContext) { _ in
            // self.loadModel()
        }
    }

}
