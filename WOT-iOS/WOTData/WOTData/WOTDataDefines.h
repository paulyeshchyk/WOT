//
//  WOTDataDefines.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOTDataDefines_h
#define WOTDataDefines_h


typedef NS_ENUM(NSInteger, WOTModuleType){
    WOTModuleTypeUnknown  = 1 << 0,
    WOTModuleTypeChassis  = 1 << 1,
    WOTModuleTypeEngine = 1 << 2,
    WOTModuleTypeRadios = 1 << 3,
    WOTModuleTypeTurrets = 1 << 4,
    WOTModuleTypeGuns = 1 << 5,
    WOTModuleTypeTank = 1 << 6
};

typedef NS_ENUM(NSInteger, WOTRequestId) {
    WOTRequestIdLogin = 0,
    WOTRequestIdSaveSession,
    WOTRequestIdLogout,
    WOTRequestIdClearSession,
    WOTRequestIdTanks,
    WOTRequestIdTankEngines,
    WOTRequestIdTankChassis,
    WOTRequestIdTankTurrets,
    WOTRequestIdTankGuns,
    WOTRequestIdTankRadios,
    WOTRequestIdTankVehicles,
    WOTRequestIdTankProfile,
    WOTRequestIdModulesTree
};

#define WOT_VALUE_APPLICATION_ID_EU @"e3a1e0889ff9c76fa503177f351b853c"
#define WOT_VALUE_APPLICATION_ID_RU @"e3a1e0889ff9c76fa503177f351b853c"

#define WOT_KEY_ACCESS_TOKEN @"access_token"
#define WOT_KEY_ACCOUNT_ID @"account_id"
#define WOT_KEY_APPLICATION_ID @"application_id"
#define WOT_KEY_ARMOR_BOARD @"armor_board"
#define WOT_KEY_ARMOR_FEDD @"armor_fedd"
#define WOT_KEY_ARMOR_FOREHEAD @"armor_forehead"
#define WOT_KEY_CIRCULAR_VISION_RADIUS @"circular_vision_radius"
#define WOT_KEY_CODE @"code"
#define WOT_KEY_CONTOUR_IMAGE @"contour_image"
#define WOT_KEY_DATA @"data"
#define WOT_KEY_DISTANCE @"distance"
#define WOT_KEY_EXPIRES_AT @"expires_at"
#define WOT_KEY_FIELDS @"fields"
#define WOT_KEY_FIRE_STARTING_CHANCE @"fire_starting_chance"
#define WOT_KEY_HASHNAME @"hashName"
#define WOT_KEY_IMAGE @"image"
#define WOT_KEY_IMAGE_SMALL @"image_small"
#define WOT_KEY_IS_GIFT @"vehicles.is_gift"
#define WOT_KEY_IS_PREMIUM @"is_premium"
#define WOT_KEY_KEY @"key"
#define WOT_KEY_LEVEL @"level"
#define WOT_KEY_DEFAULT_PROFILE_HP @"vehicles.default_profile.hp"
#define WOT_KEY_DEFAULT_PROFILE_WEIGHT @"vehicles.default_profile.weight"
#define WOT_KEY_DEFAULT_PROFILE_FIRE_RATE @"vehicles.default_profile.gun.fire_rate"
#define WOT_KEY_LOCATION @"location"
#define WOT_KEY_MAX_LOAD @"max_load"
#define WOT_KEY_MESSAGE @"message"
#define WOT_KEY_MODULE_ID @"module_id"
#define WOT_KEY_NAME @"name"
#define WOT_KEY_MODULES_TREE @"modules_tree"
#define WOT_KEY_NAME_I18N @"name_i18n"
#define WOT_KEY_DPM @"dpm"
#define WOT_KEY_NATION @"nation"
#define WOT_KEY_NATION_I18N @"nation_i18n"
#define WOT_KEY_NICKNAME @"nickname"
#define WOT_KEY_NOFOLLOW @"nofollow"
#define WOT_KEY_ORDERBY @"orderBy"
#define WOT_KEY_POWER @"power"
#define WOT_KEY_PRICE_CREDIT @"price_credit"
#define WOT_KEY_PRICE_GOLD @"price_gold"
#define WOT_KEY_PRICES_XP @"prices_xp"
#define WOT_KEY_PRICE_XP @"price_xp"
#define WOT_KEY_IS_DEFAULT @"is_default"
#define WOT_KEY_RATE @"rate"
#define WOT_KEY_REDIRECT_URI @"redirect_uri"
#define WOT_KEY_ROTATION_SPEED @"rotation_speed"
#define WOT_KEY_SETTING_TYPE @"WOT_KEY_SETTING_TYPE"
#define WOT_KEY_SETTING_TYPE_FILTER @"WOT_KEY_SETTING_TYPE_FILTER"
#define WOT_KEY_SETTING_TYPE_GROUP @"WOT_KEY_SETTING_TYPE_GROUP"
#define WOT_KEY_SETTING_TYPE_SORT @"WOT_KEY_SETTING_TYPE_SORT"
#define WOT_KEY_SHORT_NAME @"short_name"
#define WOT_KEY_SHORT_NAME_I18N @"short_name_i18n"
#define WOT_KEY_TAG @"tag"
#define WOT_KEY_TANK_ID @"tank_id"
#define WOT_KEY_TIER @"tier"
#define WOT_KEY_TYPE @"type"
#define WOT_KEY_TYPE_I18N @"type_i18n"
#define WOT_KEY_VEHICLES @"vehicles"
#define WOT_KEY_USER_ID @"userId"
#define WOT_KEY_VALUES @"values"
#define WOT_KEY_WEIGHT @"weight"
#define WOT_KEY_NEXT_MODULES @"next_modules"
#define WOT_KEY_NEXT_TANKS @"next_tanks"
#define WOT_KEY_TRAVERSE_LEFT_ARC @"traverse_left_arc"
#define WOT_KEY_TRAVERSE_RIGHT_ARC @"traverse_right_arc"
#define WOT_KEY_TRAVERSE_SPEED @"traverse_speed"
#define WOT_KEY_DEFAULT_PROFILE @"default_profile"


#define WOT_LINKKEY_MODULESTREE @"WOT_LINKKEY_MODULESTREE"
#define WOT_LINKKEY_DEFAULT_PROFILE @"WOT_LINKKEY_DEFAULT_PROFILE"
#define WOT_LINKKEY_ENGINES @"WOT_LINKKEY_ENGINES"
#define WOT_LINKKEY_GUNS @"WOT_LINKKEY_GUNS"
#define WOT_LINKKEY_RADIOS @"WOT_LINKKEY_RADIOS"
#define WOT_LINKKEY_SUSPENSIONS @"WOT_LINKKEY_SUSPENSIONS"
#define WOT_LINKKEY_TURRETS @"WOT_LINKKEY_TURRETS"

#define WOT_VALUE_VEHICLE_GUN @"WOT_VALUE_VEHICLE_GUN"
#define WOT_VALUE_VEHICLE_ENGINE @"WOT_VALUE_VEHICLE_ENGINE"
#define WOT_VALUE_VEHICLE_TURRET @"WOT_VALUE_VEHICLE_TURRET"
#define WOT_VALUE_VEHICLE_CHASSIS @"WOT_VALUE_VEHICLE_CHASSIS"
#define WOT_VALUE_VEHICLE_RADIO @"WOT_VALUE_VEHICLE_RADIO"


#define WOT_REQUEST_ID_TANK_LIST @"WOT_REQUEST_ID_TANK_LIST"
#define WOT_REQUEST_ID_LOGIN @"WOT_REQUEST_ID_LOGIN"
#define WOT_REQUEST_ID_LOGOUT @"WOT_REQUEST_ID_LOGOUT"
#define WOT_REQUEST_ID_VEHICLE_LIST @"WOT_REQUEST_ID_VEHICLE_LIST"
#define WOT_REQUEST_ID_VEHICLE_ITEM @"WOT_REQUEST_ID_VEHICLE_ITEM"
#define WOT_REQUEST_ID_VEHICLE_BY_TIER @"WOT_REQUEST_ID_VEHICLE_BY_TIER"
#define WOT_REQUEST_ID_VEHICLE_ADOPT @"WOT_REQUEST_ID_VEHICLE_ADOPT"
#define WOT_REQUEST_ID_VEHICLE_PROFILE @"WOT_REQUEST_ID_VEHICLE_PROFILE"



#endif /* WOTDataDefines_h */
