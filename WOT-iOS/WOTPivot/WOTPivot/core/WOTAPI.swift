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
    @objc public static let application_id: String = "application_id"
    @objc public static let redirectUri: String = "redirect_uri"
    @objc public static let nofollow: String = "nofollow"
    @objc public static let module_id: String = "module_id"
    @objc public static let data: String = "data"
    @objc public static let accessToken: String = "access_token"
    @objc public static let level: String = "level"
    @objc public static let name: String = "name"
    @objc public static let name_i18n: String = "name_i18n"
    @objc public static let short_name: String = "short_name"
    @objc public static let short_name_i18n: String = "short_name_i18n"
    @objc public static let type: String = "type"
    @objc public static let tier: String = "tier"
    @objc public static let nation: String = "nation"
    @objc public static let nation_i18n: String = "nation_i18n"
    @objc public static let next_modules: String = "next_modules"
    @objc public static let price_credit: String = "price_credit"
    @objc public static let is_default: String = "is_default"
    @objc public static let is_premium: String = "is_premium"
    @objc public static let price_xp: String = "price_xp"
    @objc public static let tank_id: String = "tank_id"
    @objc public static let tag: String = "tag"
    @objc public static let distance: String = "distance"
    @objc public static let price_gold: String = "price_gold"
    @objc public static let rate: String = "rate"
}

public class WOTApiTankType: NSObject, WOTAPIProtocol {
    @objc public static let at_spg: String = "AT-SPG"
    @objc public static let spg  = "SPG";
    @objc public static let lightTank  = "lightTank";
    @objc public static let mediumTank  = "mediumTank";
    @objc public static let heavyTank  = "heavyTank";
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
