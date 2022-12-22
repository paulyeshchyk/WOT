//
//  WOTTankListSettingsAvailableFieldsProtocol.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol WOTTankListSettingsAvailableFieldsProtocol {
    @objc
    var allFields: [WOTTankListSettingField] { get }

    @objc
    func isFieldBusy(_ field: WOTTankListSettingField) -> Bool 

}
