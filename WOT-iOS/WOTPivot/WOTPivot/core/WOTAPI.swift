//
//  WOTConstants.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/11/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import ObjectiveC

@objc
protocol WOTAPIProtocol: NSObjectProtocol {

}

public class WOTApiKeys: NSObject, WOTAPIProtocol {
    @objc public static let default_profile: String = "default_profile"
    @objc public static let fields: String = "fields"
    @objc public static let applicationId: String = "application_id"
    @objc public static let redirectUri: String = "redirect_uri"
    @objc public static let nofollow: String = "nofollow"
    @objc public static let moduleId: String = "module_id"
    @objc public static let data: String = "data"
    @objc public static let accessToken: String = "access_token"
    @objc public static let level: String = "level"
    @objc public static let name: String = "name"
    @objc public static let nameI18N: String = "name_i18n"
    @objc public static let short_name: String = "short_name"
    @objc public static let short_name_i18n: String = "short_name_i18n"
    @objc public static let type: String = "type"
    @objc public static let tier: String = "tier"
    @objc public static let nation: String = "nation"
    @objc public static let nation_i18n: String = "nation_i18n"
    @objc public static let next_modules: String = "next_modules"
    @objc public static let priceCredit: String = "price_credit"
    @objc public static let isDefault: String = "is_default"
    @objc public static let priceXP: String = "price_xp"
    @objc public static let tankId: String = "tank_id"
    @objc public static let tag: String = "tag"
}

@objc
protocol WOTAPIDefaultsProtocol: NSObjectProtocol {

}

public class WOTApiDefaults: NSObject, WOTAPIDefaultsProtocol {
    @objc public static let languageRU: String = "ru"
    @objc public static let languageEU: String = "eu"
    @objc public static let applicationScheme: String = "https"
    @objc public static let applicationHost: String = "api.worldoftanks"
    @objc public static let applicationRedirectURI: String = "https://api.worldoftanks.ru/wot/blank/"; //"https://ru.wargaming.net/developers/api_explorer/wot/auth/login/complete/";
}
