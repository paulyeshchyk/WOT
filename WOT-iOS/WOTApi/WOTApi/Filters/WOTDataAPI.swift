//
//  WOTDataAPI.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 2/19/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol WOTAPIProtocol: NSObjectProtocol {}

@objc
protocol WOTAPIDefaultsProtocol: NSObjectProtocol {}

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
public class WGWebRequestGroups: NSObject {
    @objc public static let vehicle_profile: RequestIdType = "vehicle_profile".hashValue
    @objc public static let vehicle_list: RequestIdType = "vehicle_list".hashValue
    @objc public static let login: RequestIdType = "login".hashValue
    @objc public static let logout: RequestIdType = "logout".hashValue
}

@objc
public class WGJsonFields: NSObject {
    @objc public static let tag: String = "tag"
    @objc public static let data: String = "data"
    @objc public static let module_id: String = "module_id"
    @objc public static let default_profile: String = "default_profile"
}

@objc
public class WOTLoginFields: NSObject {
    @objc public static let redirectUri: String = "redirect_uri"
    @objc public static let nofollow: String = "nofollow"
    @objc public static let accessToken: String = "access_token"
    @objc public static let account_id: String = "account_id"
    @objc public static let expires_at: String = "expires_at"
    @objc public static let userId: String = "userId"
    @objc public static let error: String = "error"
    @objc public static let status: String = "status"
    @objc public static let nickname: String = "nickname"
    @objc public static let code: String = "code"
    @objc public static let hashName: String = "hashName"
    @objc public static let key: String = "key"
    @objc public static let location: String = "location"
    @objc public static let message: String = "message"
    @objc public static let values: String = "values"
    @objc public static let default_profile: String = "default_profile"
}

@objc
public class WOTApiFields: NSObject, WOTAPIProtocol {
    @objc public static let modules_tree: String = "modules_tree"
    @objc public static let engines: String = "engines"
    @objc public static let suspensions: String = "suspensions"
    @objc public static let radios: String = "radios"
    @objc public static let guns: String = "guns"
    @objc public static let turrets: String = "turrets"

    @objc public static let fire_starting_chance: String = "fire_starting_chance"
    @objc public static let power: String = "power"
    @objc public static let contour_image: String = "contour_image"

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
    @objc public static let spg  = "SPG"
    @objc public static let lightTank  = "lightTank"
    @objc public static let mediumTank  = "mediumTank"
    @objc public static let heavyTank  = "heavyTank"
}

public class WOTApiDefaults: NSObject, WOTAPIDefaultsProtocol {
    @objc public static let languageRU: String = "ru"
    @objc public static let languageEU: String = "eu"
    @objc public static let applicationScheme: String = "https"
    @objc public static let applicationHost: String = "api.worldoftanks"
    @objc public static let applicationRedirectURI: String = "https://api.worldoftanks.ru/wot/blank/"; // "https://ru.wargaming.net/developers/api_explorer/wot/auth/login/complete/";
}

@objc
public class WOTApiSettingType: NSObject {
    @objc public static let key_type: String = "WOT_KEY_SETTING_TYPE"
    @objc public static let key_type_sort: String = "WOT_KEY_SETTING_TYPE_SORT"
    @objc public static let key_type_filter: String = "WOT_KEY_SETTING_TYPE_FILTER"
    @objc public static let key_type_group: String = "WOT_KEY_SETTING_TYPE_GROUP"
}

@objc
public class WOTApiKeyOrderBy: NSObject {
    @objc public static let orderBy: String = "orderBy"
}

@objc
public class WOTApiLanguage: NSObject {
    @objc public static let eu: String = "WOT_VALUE_LANGUAGE_EU"
    @objc public static let ru: String = "WOT_VALUE_LANGUAGE_RU"
    @objc public static let default_login_language: String = "WOT_USERDEFAULTS_LOGIN_LANGUAGE"
}

@objc
public class WOTApiTexts: NSObject {
    @objc public static let groupAndSort: String = "WOT_STRING_GROUP_AND_SORT"
    @objc public static let apply: String = "WOT_STRING_APPLY"
    @objc public static let image_back: String = "WOT_IMAGE_BACK"
}

@objc
public class WOTApiImages: NSObject {
    @objc public static let wotImageCheckmarkGray: String = "WOT_IMAGE_CHECKMARK_GRAY"
    @objc public static let wotImageDown: String = "WOT_IMAGE_DOWN"
    @objc public static let wotImageUp: String = "WOT_IMAGE_UP"
    @objc public static let wotImageMenuIcon: String = "WOT_IMAGE_MENU_ICON"
}
