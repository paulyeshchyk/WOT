//
//  WOTDataAPI.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 2/19/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

@objc
public protocol WOTAPIProtocol: NSObjectProtocol { }

@objc
protocol WOTAPIDefaultsProtocol: NSObjectProtocol { }

@objc
public class WOTApiForeignKeys: NSObject, WOTAPIProtocol {
    @objc public static let vehicles_default_profile_hp: String = "vehicles.default_profile.hp"
    @objc public static let vehicles_default_profile_weight: String =  "vehicles.default_profile.weight"
    @objc public static let vehicles_default_profile_gun_fire_rate: String = "vehicles.default_profile.gun.fire_rate"
}

@objc
public class WGWebQueryArgs: NSObject {
    @objc public static let fields: String = "fields"
    @objc public static let application_id: String = "application_id"
    @objc public static let module_id: String = "module_id"
    @objc public static let tank_id: String = "tank_id"
}

@objc
public class WOTApiKeys: NSObject, WOTAPIProtocol {
    @objc public static let modules_tree: String = "modules_tree"
    @objc public static let engines: String = "engines"
    @objc public static let suspensions: String = "suspensions"
    @objc public static let radios: String = "radios"
    @objc public static let guns: String = "guns"
    @objc public static let turrets: String = "turrets"

    @objc public static let fire_starting_chance: String = "fire_starting_chance"
    @objc public static let power: String = "power"
    @objc public static let contour_image: String = "contour_image"

    @objc public static let default_profile: String = "default_profile"
    @objc public static let redirectUri: String = "redirect_uri"
    @objc public static let nofollow: String = "nofollow"
    @objc public static let module_id: String = "module_id"
    @objc public static let data: String = "data"
    @objc public static let accessToken: String = "access_token"
    @objc public static let name: String = "name"
    @objc public static let short_name: String = "short_name"
    @objc public static let type: String = "type"
    @objc public static let tier: String = "tier"
    @objc public static let nation: String = "nation"
    @objc public static let next_modules: String = "next_modules"
    @objc public static let price_credit: String = "price_credit"
    @objc public static let is_default: String = "is_default"
    @objc public static let is_premium: String = "is_premium"
    @objc public static let price_xp: String = "price_xp"
    @objc public static let image_small: String = "image_small"
    @objc public static let image: String = "image"
    @objc public static let tank_id: String = "tank_id"
    @objc public static let tag: String = "tag"
    @objc public static let distance: String = "distance"
    @objc public static let price_gold: String = "price_gold"
    @objc public static let rate: String = "rate"
    @objc public static let rotation_speed: String = "rotation_speed"
    @objc public static let max_load: String = "max_load"

    @objc public static let armor_board: String = "armor_board"
    @objc public static let armor_fedd: String = "armor_fedd"
    @objc public static let armor_forehead: String = "armor_forehead"
    @objc public static let circular_vision_radius: String = "circular_vision_radius"
}

public class WOTApiTankType: NSObject, WOTAPIProtocol {
    @objc public static let at_spg: String = "AT-SPG"
    @objc public static let spg  = "SPG";
    @objc public static let lightTank  = "lightTank";
    @objc public static let mediumTank  = "mediumTank";
    @objc public static let heavyTank  = "heavyTank";
}

public class WOTApiDefaults: NSObject, WOTAPIDefaultsProtocol {
    @objc public static let languageRU: String = "ru"
    @objc public static let languageEU: String = "eu"
    @objc public static let applicationScheme: String = "https"
    @objc public static let applicationHost: String = "api.worldoftanks"
    @objc public static let applicationRedirectURI: String = "https://api.worldoftanks.ru/wot/blank/"; //"https://ru.wargaming.net/developers/api_explorer/wot/auth/login/complete/";
}
