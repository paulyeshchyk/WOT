//
//  WOTTankListSettingsAvailableFieldsProtocol.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol WOTTankListSettingsAvailableFieldsProtocol {

    var allFields: [WOTTankListSettingField] { get }
    func isFieldBusy(_ field: WOTTankListSettingField) -> Bool
}
